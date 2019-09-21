#!/bin/sh

set -x

HOME=/tmp/home
cd /tmp
wget $SOURCE
tar xvf $VERSION.tar.gz
cd js-yaml-$VERSION
npm install .
npm pack > pack.filename
filename=$PWD/"$(cat pack.filename)"

# workaround:
# npm install creates a new node_modules directory
cd /tmp
npm install --no-save $filename

mkdir -p /build/node
rsync -a node_modules /build/node/
