#!/usr/bin/env sh

set -x

# to suppress "Welcome to .NET.." FTUE message
touch "$HOME"/.dotnet/"$(dotnet --version)".dotnetFirstUseSentinel

build () {
    dotnet publish /buildutils/"$1" \
        --nologo                    \
        --output /build/bin         \
        --configuration Release     \
        --runtime linux-musl-x64
}

build event
build json
