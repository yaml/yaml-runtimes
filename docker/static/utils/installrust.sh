#!/bin/sh

set -x
cd /tmp
#cp $SOURCE .
#tar xvf ...-$VERSION.tar.gz
#cd ...-$VERSION

cp -r /buildutils/rust-yaml /tmp/
cd rust-yaml

cargo build

cp target/debug/yaml-rust-test /build/bin/yaml-rust-events
