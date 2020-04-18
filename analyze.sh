#!/bin/bash

#project=mapreduce
#for c in ResourceManager NodeManager ApplicationHistoryServer
#for c in JobHistoryServer
project=hdfs
dir=final_no_conf
#for c in HMaster HRegionServer
for c in NameNode DataNode JournalNode SecondaryNameNode
do 
    for p in hdfs yarn mapreduce hadoop-tools hbase
    do 
	num=$(./list_restart_tests_by_component.sh ./$p/$dir/ $project $c | wc -l)
	#num=$(./list_tests_by_component.sh ./$p/final/ $project $c | wc -l)
	echo "# of tests that use component $c in project $p: $num"
    done
done
