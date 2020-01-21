#!/bin/sh

set -x
cd /tmp
cp $SOURCE .
tar xvf libfyaml-$VERSION.tar.gz
cd libfyaml-$VERSION
./configure --prefix /build
make
make check
make install
