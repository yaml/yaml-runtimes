#!/bin/sh

set -x
set -e
mkdir /tmp/refparser
cd /tmp/refparser
unzip $SOURCE
ls -l

cpanm -n -l /build/perl5 boolean XXX
cd yaml-reference-parser-master
ls -l perl/lib/
ls -l /build/perl5/lib/
cp perl/bin/* /build/perl5/bin/
cp perl/lib/* /build/perl5/lib/perl5/
