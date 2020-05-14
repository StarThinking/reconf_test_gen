#!/bin/bash
if [ $# -ne 1 ]; then echo 'wrong'; exit -1; fi

grep NameNode $1 | sort -u | awk '{print $2}' > namenode.txt
grep DataNode $1 | sort -u | awk '{print $2}' > datanode.txt
grep JournalNode $1 | sort -u | awk '{print $2}' > journalnode.txt
grep Other $1 | sort -u | awk '{print $2}' > other.txt
