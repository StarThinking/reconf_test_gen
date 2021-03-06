#!/bin/bash

if [ $# -lt 2 ]; then echo 'ERROR: ./run_mvn_test.sh [project] [test_name] [optional: log_dts_dir]'; exit -1; fi

# yarn mapreduce hdfs hbase
the_project=$1
project_root_dir=$(cat /root/reconf_test_gen/"$the_project"/project_root_dir.txt)
if [ $? -ne 0 ]; then echo 'ERROR: project name is wrong'; exit -1; fi

the_test=$2
classname=$(echo $the_test | awk -F '#' '{print $1}')
testname=$(echo $the_test | awk -F '#' '{print $2}')
sub_project_classes_dir="/root/reconf_test_gen/"$the_project"/all_classes"

log_dts_dir=''
if [ $# -eq 3 ]; then log_dts_dir=$3; fi

suffix='all_classes.txt'
raw_sub_project=$(cd $sub_project_classes_dir; grep ^"$classname"$ *.txt | awk -F 'all_classes.txt' '{print $1}' | sed 's#%#/#g')
if [ "$raw_sub_project" == "" ]; then
    echo "ERROR: cannot find sub_project for $the_test"; exit -1;
fi
sub_project="$project_root_dir""$raw_sub_project"
echo "$sub_project"
exit 0
# run mvn test
cd $sub_project; mvn test -Dtest=$the_test

# log
test_log="$sub_project"/target/surefire-reports/"$the_test"-output.txt
if [ ! -f $test_log ]; then echo 'ERROR: cannot find test_log for test $the_test'; exit -1; fi
#echo "test_log is $test_log"
if [ "$log_dts_dir" != "" ]; then mv $test_log $log_dts_dir; fi

