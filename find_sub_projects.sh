#!/bin/bash

find . -name Test*.java | grep 'src\/test\/java' | awk -F 'src/test/java' '{print $1}' | sort -u | sed 's#^.#/root/hbase-2.2.4#g' > sub_projects.txt
