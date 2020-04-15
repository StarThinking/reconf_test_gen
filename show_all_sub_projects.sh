#!/bin/bash

find . -name Test*.java | grep 'src\/test\/java' | awk -F 'src/test/java' '{print $1}' | sort -u | sed 's#^.#/root/hadoop-3.2.1-src#g'
