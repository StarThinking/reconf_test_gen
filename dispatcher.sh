#!/bin/bash

if [ $# -ne 1 ]; then echo 'ERROR: ./dispatcher.sh [project]'; exit -1; fi

the_project=$1
dst='/root/reconf_test_gen/'
IFS=$'\n' 
entry_list=( $(cat task.txt) )
entry_list_length=${#entry_list[@]}
entry_cursor=0
echo entry_list_length = $entry_list_length

function is_idle {
    i=$1
    jps_num=$(docker exec hadoop-$i bash -c "jps" | wc -l)
    sh_num=$(docker exec hadoop-$i bash -c "ps aux | grep run_mvn_test.sh" | wc -l)
    if [ $jps_num -gt 1 ] || [ $sh_num -gt 2 ]; then
	echo "no"
    else
	echo "yes"
    fi
}

while [ $entry_cursor -lt $entry_list_length ]
do
    for i in $(seq 0 19)
    do
        if [ "$(is_idle $i)" == "no" ]; then
	     echo hadoop-$i is busy
	else
	    docker exec -d hadoop-$i bash -c "/root/reconf_test_gen/run_mvn_test.sh $the_project ${entry_list[$entry_cursor]} $dst"
	    echo hadoop-$i is idle, assign entry $entry_cursor to it
	    entry_cursor=$(( entry_cursor + 1 ))
	    if [ $entry_cursor -ge $entry_list_length ]; then echo finish all tasks; break; fi
	fi
    done
    sleep 1
done

for i in $(seq 0 19)
do
    while [ "$(is_idle $i)" == "no" ]; do sleep 10; done
done

echo all nodes are idle
