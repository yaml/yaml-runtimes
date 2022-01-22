#!/bin/sh

set -x
set -e
cd /tmp

# the tool is not yet in any release, and requires building.
git clone --recursive https://github.com/biojppm/rapidyaml
cd rapidyaml

cmake --version
g++ --version
cmake -S . -B build -DBUILD_SHARED_LIBS=OFF -DRYML_BUILD_TOOLS=ON
cmake --build build -j --target ryml-yaml-events
file=$(find build -name 'ryml-yaml-events*' -type f)
cp -fav $file /build/bin/ryml-yaml-events
cd ..
rm -rf rapidyaml
