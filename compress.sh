#!/bin/bash

log=$1

# we do not generate meta files if a test doesn't contain msx-reconfagent
if [ "$(cat $log | grep "msx-reconfagent" | grep -v "reconf_vvmode=none" | grep -v "creating")" == "" ]; then echo 'no init'; exit 0; fi

prefix=$(echo $log | awk -F '-output.txt' '{print $1}')
grep msx $log | grep -v 'msx-conf' > "$prefix"-component-meta.txt

rm "$prefix"-parameter-meta.txt.tmp 2> /dev/null
grep msx $log | grep 'msx-conf' | sort -u > "$prefix"-parameter-meta.txt.tmp
cat "$prefix"-parameter-meta.txt.tmp | awk -F 'msx-conf' '{print "msx-conf"$2}' > "$prefix"-parameter-meta.txt
rm "$prefix"-parameter-meta.txt.tmp

