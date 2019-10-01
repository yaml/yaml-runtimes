#!/bin/sh

set -x
cd /tmp
cp $SOURCE .
luarocks install --tree /tmp/lua lua-cjson
luarocks install --tree /tmp/lua $SOURCE

mkdir -p /build/usr/local/share
mkdir -p /build/usr/local/lib
rsync -a /tmp/lua/share/lua /build/usr/local/share/
rsync -a /tmp/lua/lib/luarocks /build/usr/local/lib/
rsync -a /tmp/lua/lib/lua /build/usr/local/lib/

