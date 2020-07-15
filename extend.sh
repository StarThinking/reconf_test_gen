#!/bin/bash

if [ $# -ne 2 ]; then echo "./extend.sh [component_log] [parameter_log]"; exit -1; fi

component_log=$1
parameter_log=$2

IFS=$'\n'
# new old table
echo > ./new_old_table.tmp
cat $component_log | grep msx-extend | while read line; do new=$(echo $line | awk '{print $3}'); old=$(echo $line | awk '{print $5}'); echo "$new $old"; done > ./new_old_table.tmp

componentConfs=( $(cat $component_log | grep performReconf | awk '{print $8}') )

for compConf in ${componentConfs[@]}
do
    for entry in $(cat ./new_old_table.tmp)
    do
	new=$(echo $entry | awk '{print $1}')
	old=$(echo $entry | awk '{print $2}')
	if [ "$old" == "$compConf" ]; then
#	    echo "conf $new is extended from conf $compConf"
	    sed -i "s/$new/$compConf/g" $parameter_log
        fi
    done
done

rm ./new_old_table.tmp
