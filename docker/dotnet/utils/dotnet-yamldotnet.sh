#!/usr/bin/env sh

set -x

cp -r /buildutils /tmp/buildutils
build () {
    dotnet publish /tmp/buildutils/"$1" \
        --nologo                        \
        --output /build/bin             \
        --configuration Release         \
        --runtime linux-musl-x64
}

build event
build json
