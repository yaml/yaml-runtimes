#!/bin/sh

set -x
cd /tmp
export GOPATH=/tmp/go
export GO111MODULE=off
go get gopkg.in/yaml.v2
LIB=$GOPATH/pkg/$( go env  GOHOSTOS )_$( go env GOHOSTARCH )
mkdir -p /build/bin
go build -o /build/bin/go-yaml-json /buildutils/go-yaml-json.go
