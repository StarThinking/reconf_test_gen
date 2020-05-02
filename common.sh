#!/bin/bash

IFS=$'\n'
if [ $# -ne 2 ]; then echo 'error'; exit -1; fi
if [ ! -f $1 ] || [ ! -f $2 ]; then echo 'error'; exit -1; fi

list1=( $(cat $1) )
list2=( $(cat $2) )

echo "size of list1: ${#list1[@]}"
echo "size of list2: ${#list2[@]}"

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
echo "list1_uniq_count: $list1_uniq_count"

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
echo "list2_uniq_count: $list2_uniq_count"

echo "list1_uniq:"
for i in ${list1_uniq[@]}; do echo $i; done

echo "list2_uniq:"
for i in ${list2_uniq[@]}; do echo $i; done
