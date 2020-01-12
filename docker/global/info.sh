#!/bin/sh

[[ -d /yaml/info ]] || exit 0

for i in /yaml/info/*.yaml; do
    cat $i
done
