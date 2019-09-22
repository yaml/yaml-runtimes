#!/bin/sh

set -x
HOME=/tmp/home
pip3 install --install-option="--prefix=/build/python" $SOURCE

