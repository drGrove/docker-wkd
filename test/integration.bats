#!/usr/bin/env bats

setup() {
  if [ "$CI" == true ]; then
    VERSION=$CIRCLE_SHA1
  else
    VERSION=$(cat $PWD/VERSION)
  fi
}

@test "hu folder generates with expected file" {
  docker run -v $PWD/test/data:/data/ -v $PWD/test/hu:/root/hu/ -e MAIL_DOMAIN=drgrovellc.com drgrove/wkd:$VERSION
  [ -f "$PWD/test/hu/57f91moszq5u15no4a59pp7pujgeaj4c" ]
}
