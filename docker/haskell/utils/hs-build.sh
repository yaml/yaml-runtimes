#!/bin/sh

set -ex
cd /tmp
cp -p $SOURCE .

    case $LIBNAME in
    hs-hsyaml)
        build_file=yaml-test
        target_file=hsyaml-parser
        unzip $VERSION.zip
        cd HsYAML-$VERSION
    ;;
    hs-reference)
        build_file=yaml2yeast
        target_file=yaml2yeast
        unzip $VERSION.zip
        cd yamlreference-$VERSION
    ;;
    *)
      echo "$LIBNAME not supported"
      exit 1
    ;;
esac

cabal update
cabal new-build "exe:$build_file"

build_file=$(find dist-newstyle -name $build_file -type f -executable)

mkdir -p /build/bin
cp "$build_file" /build/bin/$target_file

