#!/bin/sh

set -x

HOME=/tmp/home
cd /tmp
cp -p $SOURCE .
tar xvf v${VERSION}.tar.gz
cd NimYAML-$VERSION
nim c -p:$PWD -d:yamlScalarRepInd /buildutils/nimyaml_event.nim
mkdir -p /build/bin
mv /buildutils/nimyaml_event /build/bin/
