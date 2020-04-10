#!/bin/bash

num=19
key='output.txt'
file_src_dir=/root/reconf_test_gen/

function fetch {
    d=$1
    files=$(docker exec hadoop-$d bash -c "ls $file_src_dir | grep $key")
    for f in ${files[@]}; do docker cp hadoop-$d:$file_src_dir/$f . ; done
    #for f in ${files[@]}; do echo $f; done
}

for i in $(seq 0 $num)
do
    fetch $i &
    pids[$i]=$!
done

for i in $(seq 0 $num)
do
    wait ${pids[$i]}
done

echo "all files with key $key are fetched"
