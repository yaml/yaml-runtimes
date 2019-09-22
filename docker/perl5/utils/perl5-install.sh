#!/bin/sh

set -x

cpanm --notest $SOURCE -l /build/perl5
