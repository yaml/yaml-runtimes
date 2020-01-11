#!/bin/sh

set -x

# TODO install from tar archive
zef install -v --install-to=/raku "JSON::Tiny"
zef install -v --install-to=/raku "Data::Dump"
zef install -v --install-to=/raku "YAMLish:ver<$VERSION>"

cp -r /rakudo /build/
