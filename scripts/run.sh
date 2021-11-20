#!/bin/ash

set -e

dir=/shared

/scripts/read.sh >"$dir/$RUNTIME-log" 2>&1
