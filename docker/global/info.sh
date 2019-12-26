#!/bin/sh

[[ -d /yaml/info ]] || exit 0

for i in /yaml/info/*; do
    cat $i
done
