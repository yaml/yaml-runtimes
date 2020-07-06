#!/bin/sh

echo "Building go-goccy"

rm -fR /tmp/gopath
mkdir /tmp/gopath
export GOPATH=/tmp/gopath

cp -pr /buildutils/src/go-goccy-json /build/go-goccy-json
cd /build/go-goccy-json
rm go.sum

sed -i -e "s/goccy.go-yaml .*/goccy\/go-yaml v$VERSION/" go.mod
echo ' === go.mod:'
cat go.mod
echo ' === end go.mod'

echo ' === in: ' $(pwd)
go build -v .
