#!/usr/bin/env bats

setup() {
  VERSION=$(git describe --tags)
}

@test "Docker image builds" {
  docker build -t drgrove/wkd:$VERSION $PWD/
  result="$(docker images drgrove/wkd:$VERSION | grep $VERSION | awk '{print $2}')"
  [ "$result" == "$VERSION" ]
}


