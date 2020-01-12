#!/bin/sh

set -x

cd /tmp
cp $SOURCE .
tar xvf v$VERSION.tar.gz
cd yaml-$VERSION
npm install .
npm run build
npm pack > pack.filename
filename=$PWD/"$(cat pack.filename)"

# workaround:
# npm install creates a new node_modules directory
cd /tmp
npm install --no-save $filename

mkdir -p /build/node
rsync -a node_modules /build/node/
