#!/usr/bin/env sh

set -x

# to suppress "Welcome to .NET.." FTUE message
touch "$HOME"/.dotnet/"$(dotnet --version)".dotnetFirstUseSentinel

cp -r /buildutils /tmp/buildutils
build () {
    dotnet publish /tmp/buildutils/"$1" \
        --nologo                    \
        --output /build/bin         \
        --configuration Release     \
        --runtime linux-musl-x64
}

build event
build json
