#!/bin/bash
rm ./para.tmp.txt
cat $1 | grep -v '\]$' >> ./para.tmp.txt
cat $1 | grep '\]$' | grep '\[' | awk -F '[' '{print $1"[*]"}' >> ./para.tmp.txt
cat ./para.tmp.txt | sort -u
