#!/bin/bash
cat $1 | grep -v '\]$'
cat $1 | grep '\]$' | awk -F '\[' '{print $1"[*]"}' | sort -u
