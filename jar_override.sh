#!/bin/bash

if [ $# -ne 1 ]; then echo 'ERROR'; exit -1; fi

IFS=$'\n'

for line in $(cat $1)
do 
    jar_name="$(echo $line | awk '{print $1}')"
    jar_path="$(echo $line | awk '{print $2}')"
    mvn_jar_path_num=$(find /root/.m2/ -name $jar_name | wc -l)
    mvn_jar_path=$(find /root/.m2/ -name $jar_name)
    if [ $mvn_jar_path_num -eq 0 ]; then
	echo "$jar_name not used in mvn"
    elif [ $mvn_jar_path_num -eq 1 ]; then 
	echo "use $jar_path to override $mvn_jar_path"
       	cp $jar_path $mvn_jar_path
    else 
        echo "ERROR: $jar_name"; exit -1; 
    fi
done
