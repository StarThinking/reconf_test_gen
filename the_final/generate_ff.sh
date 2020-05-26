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

for p in hdfs hbase yarn mapreduce hadoop-tools
do
    logs=$(grep -r ^"$parameter " $p/final/ultimate | awk -F '-ultimate-meta.txt' '{print $1"-ultimate-meta.txt"}' | sort -u)

    for log in ${logs[@]}
    do
	#echo log is $log
        
    	the_proj="$(echo $log | awk -F '/' '{print $1}')"
        the_test="$(echo $log | awk -F '/' '{print $4}' | awk -F '-ultimate-meta.txt' '{print $1}')"

        component_inits=( $(cat $log | grep ^"$parameter " | awk '{print $2}' | sort -u | grep -v OtherComponent | awk -F '.' '{print $1}' | uniq -c | awk '{print $2" "$1}') )
	#echo ${component_inits[@]}	
    	# add the default value used for this component at this point and create value pairs	
        value_used=( $(cat $log | grep ^"$parameter " | awk '{print $3}' | sort -u | grep -v OtherComponent | head -n 1) )       
    	v_list[0]="$value_used"
    	v_pairs=( $(get_combo ${v_list[@]}) )
	
	for component_init in ${component_inits[@]}
	do
	    the_component=$(echo $component_init | awk '{print $1}')
	    the_inits=$(echo $component_init | awk '{print $2}')
    	    for v_p in ${v_pairs[@]}
	    do
	 	if [ $the_inits -eq 1 ]; then
		    echo "$parameter"" ""$the_proj"" ""$the_test"" ""$the_component"" ""$the_inits"" ""$v_p"
	 	else
	            echo "$parameter"" ""$the_proj"" ""$the_test"" ""$the_component"" -1 ""$v_p"
	            echo "$parameter"" ""$the_proj"" ""$the_test"" ""$the_component"" -2 ""$v_p"
		fi
	        #for the_init in $(seq 1 $the_inits)
	  	#do
		#    if [ $the_init -eq 1 ]; then
	        #        echo "$parameter"" ""$the_proj"" ""$the_test"" ""$the_component"" ""$the_init"" ""$v_p"
		#    else
	        #        echo "$parameter"" ""$the_proj"" ""$the_test"" ""$the_component"" ""$the_init"" ""$v_p"
	        #        echo "$parameter"" ""$the_proj"" ""$the_test"" ""$the_component"" ""$the_init"" ""$v_p"
		#    fi
    	        #done
	    done
	done
    done
done
