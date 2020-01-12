#!/bin/sh

set -x
cd /tmp
cp $SOURCE .
tar xvf libfyaml-$VERSION.tar.gz
cd libfyaml-$VERSION
patch -p1 < /buildutils/libfyaml-patch-qsort.patch
./configure --prefix /build
make
make check
make install
