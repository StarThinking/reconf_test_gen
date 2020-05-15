#!/bin/bash
if [ $# -ne 1 ]; then echo 'wrong'; exit -1; fi

grep NameNode $1 | sort -u | awk '{print $2}' > NameNode.txt
grep DataNode $1 | sort -u | awk '{print $2}' > DataNode.txt
grep JournalNode $1 | sort -u | awk '{print $2}' > JournalNode.txt
grep ApplicationHistoryServer $1 | sort -u | awk '{print $2}' > ApplicationHistoryServer.txt
grep NodeManager $1 | sort -u | awk '{print $2}' > NodeManager.txt
grep ResourceManager $1 | sort -u | awk '{print $2}' > ResourceManager.txt
grep Other $1 | sort -u | awk '{print $2}' > Other.txt
