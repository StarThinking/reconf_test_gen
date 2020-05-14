#!/bin/bash

IFS=$'\n'
if [ $# -ne 3 ]; then echo 'error'; exit -1; fi
if [ ! -f $1 ] || [ ! -f $2 ]; then echo 'error'; exit -1; fi

scope=/root/reconf_test_gen/$3/all_parameters.txt
list1_raw=( $(cat $1) )
for p in ${list1_raw[@]}
do
    if [ "$(grep ^"$p"$ $scope)" != "" ]; then list1+=("$p"); fi
done
list2_raw=( $(cat $2) )
for p in ${list2_raw[@]}
do
    if [ "$(grep ^"$p"$ $scope)" != "" ]; then list2+=("$p"); fi
done

echo '----------------------------------------------------------------------'
echo "size of $1: ${#list1[@]}"
echo "size of $2: ${#list2[@]}"

common_count=0
for i in ${list1[@]}
do 
    for j in ${list2[@]}
    do
	if [ "$j" == "$i" ]; then
            common_count=$(( common_count + 1 ))
	    break
        fi
    done
done
echo "common_count: $common_count"

list1_uniq_count=0
for i in ${list1[@]}
do 
    found=0
    for j in ${list2[@]}
    do
	if [ "$j" == "$i" ]; then
	    found=1
	    break
        fi
    done
    if [ $found -eq 0 ]; then list1_uniq+=("$i"); list1_uniq_count=$(( list1_uniq_count + 1 )); fi
done
echo "unique in $1: $list1_uniq_count"

list2_uniq_count=0
for i in ${list2[@]}
do 
    found=0
    for j in ${list1[@]}
    do
	if [ "$j" == "$i" ]; then
	    found=1
	    break
        fi
    done
    if [ $found -eq 0 ]; then list2_uniq+=("$i"); list2_uniq_count=$(( list2_uniq_count + 1 )); fi
done
echo "unique in $2: $list2_uniq_count"

echo '----------------------------------------------------------------------'
echo "unique list in $1:"
for i in ${list1_uniq[@]}; do echo $i; done
echo '----------------------------------------------------------------------'
echo "unique list in $2:"
for i in ${list2_uniq[@]}; do echo $i; done
echo '----------------------------------------------------------------------'
