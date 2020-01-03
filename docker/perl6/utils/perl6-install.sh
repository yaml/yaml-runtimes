#!/bin/sh

set -x

# TODO install from tar archive
mkdir -p /build/perl6
zef install -v --install-to=/build/perl6 "JSON::Tiny"
zef install -v --install-to=/build/perl6 "Data::Dump"
zef install -v --install-to=/build/perl6 "YAMLish:ver<$VERSION>"
