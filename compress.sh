#!/bin/bash

log=$1

if [ "$(grep msx $log | grep -v msx-listener | grep -v msx-conf )" == "" ]; then echo 'no init'; exit 0; fi

prefix=$(echo $log | awk -F '-output.txt' '{print $1}')
grep msx $log | grep -v msx-conf > "$prefix"-component-meta.txt
grep msx $log | grep msx-conf | sort -u > "$prefix"-parameter-meta.txt
