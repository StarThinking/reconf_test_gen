#!/bin/bash

for i in $(grep -oP "node-[0-9]{1,2}$" /etc/hosts | sed 's/node-//g' | sort -n)
do 
    ssh node-$i 'rm ~/reconf_test_gen/target/*; ~/parameter_test_controller/container_utility_sh/docker_fetch_result.sh .txt ~/reconf_test_gen/target/ ~/reconf_test_gen/target/' &
    pids0[$i]=$!
done

for p in ${pids0[@]}
do
    wait $p; echo "$p finished tranferring"
done

#for i in $(grep -oP "node-[0-9]{1,2}$" /etc/hosts | sed 's/node-//g' | sort -n)
#do 
#    ssh node-$i 'cd ~/reconf_test_gen/target/; for l in *; do ~/reconf_test_gen/compress.sh $l; done;' &
#    pids1[$i]=$!
#done
#
#for p in ${pids1[@]}
#do
#    wait $p; echo "$p finished compression"
#done
#    
for i in $(grep -oP "node-[0-9]{1,2}$" /etc/hosts | sed 's/node-//g' | sort -n)
do
    scp node-$i:~/reconf_test_gen/target/* .
done
