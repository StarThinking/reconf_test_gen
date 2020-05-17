#!/bin/bash

#for i in $(grep -oP "node-[0-9]{1,2}$" /etc/hosts | sed 's/node-//g' | sort -n)
for i in $(seq 1 17)
do 
    ssh node-$i 'rm ~/reconf_test_gen/target/*; ~/parameter_test_controller/container_utility_sh/docker_fetch_compress_result.sh .txt ~/reconf_test_gen/target/ ~/reconf_test_gen/target/' &
    pids0[$i]=$!
done

for p in ${pids0[@]}
do
    wait $p; echo "$p finished compressing and tranferring"
done
    
#for i in $(grep -oP "node-[0-9]{1,2}$" /etc/hosts | sed 's/node-//g' | sort -n)
for i in $(seq 1 17)
do
    scp node-$i:~/reconf_test_gen/target/* .
done
