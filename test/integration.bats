#!/usr/bin/env bats

setup() {
  if [ "$CI" == true ]; then
    VERSION=$TRAVIS_COMMIT
  else
    VERSION=$(cat $PWD/VERSION)
  fi
}

teardown() {
  [ -d "$PWD/test/hu" ] && echo "Removing test output folder, this requires sudo" && sudo rm -rf $PWD/test/hu/*
}

@test "hu folder generates with expected file using keys file" {
  run docker run -v $PWD/test/data/file:/data/ -v $PWD/test/hu:/root/hu/ drgrove/wkd:$VERSION -m drgrovellc.com
  [ "$status" -eq 0 ]
  [ -f "$PWD/test/hu/57f91moszq5u15no4a59pp7pujgeaj4c" ]
}

@test "hu folder generates with expected file using keys folder" {
  run docker run -v $PWD/test/data/folder:/data/ -v $PWD/test/hu:/root/hu/ drgrove/wkd:$VERSION --use-folder /data/ -m drgrovellc.com
  [ "$status" -eq 0 ]
  [ -f "$PWD/test/hu/57f91moszq5u15no4a59pp7pujgeaj4c" ]
}

@test "A user can only use either a file or a folder, but not both" {
  run docker run -v $PWD/test/data:/data/ -v $PWD/test/hu:/root/hu/ -e MAIL_DOMAIN=drgrovellc.com drgrove/wkd:$VERSION --use-file /data/file/keys.txt --use-folder /data/folder/
  echo "$status: $output"
  [ "$status" -eq 1 ]
}

@test "Invalid folder throws an error" {
  run docker run -v $PWD/test/data/file:/data/ -v $PWD/test/hu:/root/hu/ -e MAIL_DOMAIN=drgrovellc.com drgrove/wkd:$VERSION --use-folder /foo/
  [ "$status" -eq 1 ]
}

@test "Missing mail flag or MAIL_DOMAIN env variable throws and error" {
  run docker run -v $PWD/test/data/file:/data/ -v $PWD/test/hu:/root/hu/ drgrove/wkd:$VERSION
  [ "$status" -eq 1 ]
}

@test "Updating a keyring can be skipped" {
  run docker run -v $PWD/test/data/file:/data/ -v $PWD/test/hu:/root/hu/ drgrove/wkd:$VERSION -s -m drgrovellc.com
  [ "$status" -eq 0 ]
}
