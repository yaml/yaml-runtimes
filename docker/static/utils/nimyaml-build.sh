#!/bin/sh

set -x

cd /tmp
cp $SOURCE .
tar xvf v${VERSION}.tar.gz
cd NimYAML-$VERSION
nim c -p:$PWD -d:yamlScalarRepInd /buildutils/nimyaml_event.nim
mkdir -p /build/bin
mv /buildutils/nimyaml_event /build/bin/
