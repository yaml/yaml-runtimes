#!/bin/sh

set -x
cd /tmp

cp $SOURCE .
tar xvf rapidyaml-$VERSION-src.tgz
cd rapidyaml-$VERSION-src

cmake --version
cmake -S . -B ./build \
  -DRYML_BUILD_TOOLS=ON -DRYML_WITH_TAB_TOKENS=ON \
  -DBUILD_SHARED_LIBS=OFF -DCMAKE_BUILD_TYPE=Debug
cmake --build ./build -j --target ryml-yaml-events
file=$(find ./build -name 'ryml-yaml-events*' -type f)
cp -fav $file /build/bin/ryml-yaml-events

