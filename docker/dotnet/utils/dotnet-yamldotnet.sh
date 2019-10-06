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

  # change permission from 744 to 755 (otherwise we
  # get "permission denied" in runtime container)
  chmod 755 /build/bin/*$1
}

build event
build json
