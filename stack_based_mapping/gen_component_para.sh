#!/bin/bash
if [ $# -ne 1 ]; then echo 'wrong'; exit -1; fi

for component in NameNode DataNode JournalNode ApplicationHistoryServer NodeManager ResourceManager Other 
do
    grep ' is used by ' $1 | grep "$component"$ | awk '{print $2}' | sort -u > "$component".txt
done
