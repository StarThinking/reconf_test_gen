#!/bin/bash

if [ $# != 2 ]; then echo 'ERROR: ./run_mvn_test.sh [project] [test_name]'; exit -1; fi

# yarn mapreduce hdfs hbase
the_project=$1
project_root_dir=$(cat /root/reconf_test_gen/"$the_project"/project_root_dir.txt)
if [ $? -ne 0 ]; then echo 'ERROR: project name is wrong'; exit -1; fi

the_test=$2
classname=$(echo $the_test | awk -F '#' '{print $1}')
testname=$(echo $the_test | awk -F '#' '{print $2}')
sub_project_classes_dir="/root/reconf_test_gen/"$the_project"/all_classes"

suffix='all_classes.txt'
raw_sub_project=$(cd $sub_project_classes_dir; grep ^"$classname"$ *.txt | awk -F 'all_classes.txt' '{print $1}' | sed 's#%#/#g')
if [ "$raw_sub_project" == "" ]; then
    echo "ERROR: cannot find sub_project for $the_test"; exit -1;
fi
sub_project="$project_root_dir""$raw_sub_project"
echo "sub_project for $the_test is $sub_project"

# run mvn test
#for sub in ${sub_projects[@]}
#do
#    echo $sub; cd $sub; mvn test > mvn_result.txt
#done

