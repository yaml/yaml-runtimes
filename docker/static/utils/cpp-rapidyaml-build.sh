#!/bin/sh

set -xe
cd /tmp

#override_version=master
if [ "$override_version" != "" ] ; then
    tag=$override_version
    mkdir rapidyaml-$tag
    cd rapidyaml-$tag
    git init -q .
    git remote add origin https://github.com/biojppm/rapidyaml
    git fetch origin $tag
    git reset --hard FETCH_HEAD
    git submodule update --init --recursive
else
    cp $SOURCE .
    tar xvf rapidyaml-$VERSION-src.tgz
    cd rapidyaml-$VERSION-src
fi

cmake --version
cmake -S . -B ./build \
  -DRYML_BUILD_TOOLS=ON \
  -DRYML_WITH_TAB_TOKENS=ON \
  -DRYML_DEFAULT_CALLBACK_USES_EXCEPTIONS=ON \
  -DBUILD_SHARED_LIBS=OFF \
  -DCMAKE_BUILD_TYPE=Release
cmake --build ./build -j --target ryml-yaml-events
cmake --build ./build -j --target ryml-parse-emit

file=$(find ./build -name 'ryml-yaml-events*' -type f)
mkdir -p /build/bin/
cp -fav $file /build/bin/ryml-yaml-events

file=$(find ./build -name 'ryml-parse-emit*' -type f)
mkdir -p /build/bin/
cp -fav $file /build/bin/ryml-parse-emit
