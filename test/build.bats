#!/usr/bin/env bats

setup() {
  if [ "$CI" == true ]; then
    VERSION=$CIRCLE_SHA1
  else
    VERSION=$(cat $PWD/VERSION)
  fi
}

@test "Docker image builds" {
  docker build -t drgrove/wkd:$VERSION $PWD/
  result="$(docker images drgrove/wkd:$VERSION | grep $VERSION | awk '{print $2}')"
  [ "$result" == "$VERSION" ]
}


