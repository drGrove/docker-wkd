#!/usr/bin/env bats

setup() {
  if [ "$CI" == true ]; then
    VERSION=$TRAVIS_COMMIT
  else
    VERSION=$(cat $PWD/VERSION)
  fi
}

@test "Docker image builds" {
  docker build -t drgrove/wkd:$VERSION $PWD/
  result="$(docker images drgrove/wkd:$VERSION | grep $VERSION | awk '{print $2}')"
  [ "$result" == "$VERSION" ]
}


