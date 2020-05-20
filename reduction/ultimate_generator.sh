#!/bin/bash

IFS=$'\n'

if [ $# -ne 2 ]; then echo '[parameter]'; exit -1; fi

parameter=$1
default_value=$2

combo() { python -c "import sys, itertools; a=sys.argv[1:]; print '\n'.join('\n'.join(' '.join(str(i) for i in c) for c in itertools.combinations(a, i)) for i in range(1, len(a)+1))" "$@"; }

function get_combo {
    array=( $(echo "$@" | awk -F ' ' '{for(i=1; i<=NF; i++) print $i}') )
    array_num=${#array[@]}
    for i in $(seq 1 $(( array_num - 1 )))
    do
	if [ "${array[0]}" != "${array[$i]}" ]; then
            echo "${array[0]} ${array[$i]}"
            echo "${array[$i]} ${array[0]}"
	fi
    done
}

# first value always occur
declare -A user_defined_v_list_hashmap
user_defined_v_list_hashmap['dfs.blockreport.initialDelay']="100 200 300"

v_list=()
function return_v_list {
    p=$1
    v=$2
    v_list=()
    
    if [ "${user_defined_v_list_hashmap["$p"]}" != "" ]; then
	array=( $(echo "${user_defined_v_list_hashmap["$p"]}" | awk -F ' ' '{for(i=1; i<=NF; i++) print $i}') )
        array_num=${#array[@]}
	for i in $(seq 0 $(( array_num - 1 )))
	do
	    v_list+=("${array[$i]}")
	done
	return
    fi
    
    if [ "$v" == "true" ] || [ "$v" == "false" ]; then
        v_list+=("true")
        v_list+=("false")
	return
    fi

    if [[ $v =~ ^-?[0-9]+$ ]]; then
        if [ $v -eq -1 ]; then  # -1
	    v_list+=(-1)
	    v_list+=(1)
	    v_list+=(8)
	    v_list+=(1024)
	elif [ $v -eq 0 ]; then  # 0
            v_list+=(0)
            v_list+=(1)
            v_list+=(8)
            v_list+=(1024)
	elif [ $v -eq 1 ]; then  # 1
            v_list+=(1)
            v_list+=(2)
            v_list+=(8)
            v_list+=(1024)
	elif [ $v -ge 2 ] && [ $v -le 9 ]; then  # [2, 9]
	    v_list+=($v)
	    v_prime=$(( v * 2 ))
	    v_list+=($v_prime)
	    v_prime=$(( v / 2 ))
	    v_list+=($v_prime)
	    v_prime=$(( v * 16 ))
	    v_list+=($v_prime)
	    v_prime=1
	    v_list+=($v_prime)
	elif [ $v -ge 10 ] && [ $v -le 1000 ]; then # [11, 1000]
	    v_list+=($v)
	    v_prime=$(( v * 8 ))
	    v_list+=($v_prime)
	    v_prime=$(( v / 8 ))
	    v_list+=($v_prime)
	    v_prime=$(( v * 1024 ))
	    v_list+=($v_prime)
	    v_prime=1
	    v_list+=($v_prime)
	elif [ $v -ge 1001 ] ;then
	    v_list+=($v)
	    v_prime=$(( v * 2 ))
	    v_list+=($v_prime)
	    v_prime=$(( v / 2 ))
	    v_list+=($v_prime)
	    v_prime=$(( v * 64 ))
	    v_list+=($v_prime)
	    v_prime=1
	    v_list+=($v_prime)
	else
	    echo 'ERROR to reach here'
        fi
	return
    fi
    echo "do not support right now, need maunal setting"
}

return_v_list $parameter $default_value
#echo ${v_list[@]}
get_combo ${v_list[@]}

#get_combo "1" "2" "3" 
#
#for proj in mapreduce hadoop-tools
#do
#    for log in /root/reconf_test_gen/$proj/final/ultimate/*
#    do
#        if [ "$(grep ^"$parameter " $log)" != "" ]; then
#	    echo $log
#	    
#	fi
#    done
#done
