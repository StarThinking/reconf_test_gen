#!/bin/bash

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

IFS=$'\n'
if [ $# -ne 1 ]; then echo 'wrong: [parameter]'; exit -1; fi

parameter=$1

# create v_list
para_value_list_dir='/root/reconf_test_gen/the_final/para_value_list'
if [ $(grep -r ^"$parameter " $para_value_list_dir | wc -l) -ne 1 ]; then
    echo "ERROR: check $parameter value list!"
    exit -1
fi
prior_v_list=( $(grep -r ^"$parameter " $para_value_list_dir | awk -F ':' '{print $2}' | awk '{for(i=2;i<=NF;i++) print $i}') )
v_index=1
for v in ${prior_v_list[@]}
do
    v_list[$v_index]="$v"
    v_index=$(( v_index + 1 ))
done

for log in $(find . -name '*-ultimate-meta.txt')
do
    # per log
    declare -A component_count_map
    
    quick_look_log="$(grep ^"$parameter " $log)"
    if [ "$quick_look_log" == "" ]; then continue; fi
    
    for line in $(cat $log)
    do
	quick_look_line="$(echo $line | grep ^"$parameter ")"
	if [ "$quick_look_line" == "" ]; then continue; fi
    	
	the_proj="$(echo $log | awk -F '/' '{print $2}')"
    	the_test="$(echo $log | awk -F '/' '{print $5}' | awk -F '-ultimate-meta.txt' '{print $1}')"
	the_component="$(echo "$line" | awk '{print $2}' | awk -F '.' '{print $1}')"
	the_value="$(echo "$line" | awk '{print $3}')"
	if [ "$the_component" == "OtherComponent" ] ;then continue; fi

        # update component_count_map
	if [ "${component_count_map["$the_component"]}" == "" ]; then 
	    component_count_map["$the_component"]=1; 
	else
	    current_v=${component_count_map["$the_component"]}
	    component_count_map["$the_component"]=$(( current_v + 1 ))
	fi
	tuple_head="$parameter"" ""$the_proj"" ""$the_test"" ""$the_component"" ""${component_count_map["$the_component"]}"

	# add the default value used for this component at this point
	# create value pairs	
	v_list[0]="$the_value"
	v_pairs=( $(get_combo ${v_list[@]}) )
	for v_p in ${v_pairs[@]}; do echo "$tuple_head"" ""$v_p"; done
    done
done
