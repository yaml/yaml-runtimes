#!/bin/sh

set -x
HOME=/tmp/home
cpanm --notest $SOURCE -l /build/perl5
