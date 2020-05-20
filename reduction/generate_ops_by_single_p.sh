#!/bin/bash

IFS=$'\n'

combo() { python -c "import sys, itertools; a=sys.argv[1:]; print '\n'.join('\n'.join(' '.join(str(i) for i in c) for c in itertools.combinations(a, i)) for i in range(1, len(a)+1))" "$@"; }

function get_combo {
    array=$(combo $(echo $@ | awk -F ' ' '{for(i=1;i<=NF;i++) print $i" "}'))
    #array=$(combo $@)
    for i in ${array[@]}
    do
	echo $i | awk -F ' ' '{if (NF == 2) print $1" "$2}'
	#echo $i | awk -F ' ' '{if (NF == 2) print $2" "$1}'
    done
}

# all components
hdfs_components+=('NameNode')
hdfs_components+=('DataNode')
hdfs_components+=('JournalNode')
hdfs_components+=('SecondaryNameNode')
yarn_components+=('ResourceManager')
yarn_components+=('NodeManager')
yarn_components+=('ApplicationHistoryServer')
mapreduce_components+=('JobHistoryServer')
hbase_components+=('HMaster')
hbase_components+=('HRegionServer')

if [ $# -ne 2 ]; then echo 'wrong: [component_project] [parameter_entry]'; exit -1; fi
component_project=$1
parameter_entry="$2"

parameter_entries=( $(echo "$parameter_entry") )
para_num=${#parameter_entries[@]}

component_array="$component_project"_components[@]
components=( $(for c in ${!component_array}; do echo $c; done) ) # dynamically create a new array
root_dir='/root/reconf_test_gen'
white_list_file="/root/reconf_test_gen/""$component_project""/xml/white_list.txt"
if [ ! -f $white_list_file ]; then echo "$white_list_file not exists, exit."; exit -1; fi

white_list_check_enable='false' # global

function is_in_white_list {
    if [ "$white_list_check_enable" == "false" ]; then return 0; fi

    parameter=$1
    if [ "$(grep ^"$parameter"$ $white_list_file)" != "" ]; then
	return 1
    else
	return 0
    fi
}

function init_count {
    log_file=$1
    project=$2
    component=$3
    inited=0
    while IFS=$'\n' read -r line
    do
        if [[ "$line" == "msx-reconfagent $component init"* ]]; then
	inited=$(( inited + 1))
        fi
    done < "$log_file"
    return $inited
}

paramter_test_mappping_enable='false' # global
component_paramter_test_mappping_enable='false' # global
function para_used_in_test {
    log_file=$1
    parameter=$2
    component=$3 # not used when component_paramter_test_mappping_enable is falss

    if [ "$paramter_test_mappping_enable" == "false" ]; then return 1; fi

    used=0
    component_used=0
    if [ "$(grep " $parameter " $log_file)" != "" ]; then used=1; fi

    if [ "$component_paramter_test_mappping_enable" == "false" ]; then 
	return $used
    else
	if [ "$(grep " $parameter " $log_file | grep " $component"$)" != "" ]; then component_used=1; return $component_used; fi
    fi

    return $component_used
}

function para_used_in_component_test {
    log_file=$1
    parameter=$2
    component=$3

    if [ "$component_paramter_test_mappping_enable" == "false" ]; then return 1; fi

    used=0
    if [ "$(grep " $parameter " $log_file | grep " $component"$)" != "" ]; then used=1; fi
    return $used
}

function get_tests_by_component_project {
    local_op_count=0
    parameter=$1
    component=$2
    v1=$3
    v2=$4
    component_analysis_dir="$root_dir"/"$component_project"/component_analysis/
    cd $component_analysis_dir
    
    for inited in "$component_project"_"$component"_inited_in_*
    do
	test_project=$(echo $inited | awk -F '_|.txt' '{print $5}')
        component_log_suffix='-component-meta.txt'
        parameter_log_suffix='-parameter-meta.txt'
        final_component_dir='final/component'
        final_parameter_dir='final/parameter'
        
        for test in $(cat $inited)
        do
    	    component_log="/root/reconf_test_gen/"$test_project"/"$final_component_dir"/"$test""$component_log_suffix""
    	    parameter_log="/root/reconf_test_gen/"$test_project"/"$final_parameter_dir"/"$test""$parameter_log_suffix""
    	    init_count $component_log $component_project $component
    	    init_point_num=$?
	    para_used_in_test $parameter_log $parameter $component
	    p_used=$?
	    if [ $p_used -eq 0 ]; then continue; fi
	    for init_p in $(seq 1 $init_point_num)
	    do
    	        #echo "$parameter $component $v1 $v2 $test_project $test $init_p"
    	        #echo "$parameter $component $v2 $v1 $test_project $test $init_p"
	        local_op_count=$(( local_op_count + 2 ))
 	    done
        done
    done
    echo $local_op_count
}

function c2t_reduce {
    op_count_sum=0
    paramter_test_mappping_enable='false'
    para='dummy'

    for compo in ${components[@]}
    do
        ops=$(get_tests_by_component_project $para $compo)
	op_count_sum=$(( op_count_sum + ops ))
    done
    op_count_sum=$(( op_count_sum * para_num ))
    echo $op_count_sum
}

function c2t_plus_p2t_reduce {
    op_count_sum=0
    paramter_test_mappping_enable='true'
    for entry in ${parameter_entries[@]}
    do
        para=$(echo $entry | awk -F ' ' '{print $1}')
	values=$(echo $entry | cut -d ' ' -f 2-)
	#echo "values = ${values[@]}"
	v_pairs=( $(get_combo $values) )
	
	is_in_white_list $para
	if [ $? -eq 1 ]; then continue; fi # skip if parameter is in white list
        
	for pair in ${v_pairs[@]}
 	do
	    v1=$(echo $pair | awk -F ' ' '{print $1}')
	    v2=$(echo $pair | awk -F ' ' '{print $2}')
	    for compo in ${components[@]}
            do
        	ops=$(get_tests_by_component_project $para $compo $v1 $v2)
        	#get_tests_by_component_project $para $compo $v1 $v2
		op_count_sum=$(( op_count_sum + ops ))
            done
	done
    done
    echo $op_count_sum
}

function c2t_plus_p2t_plus_p2c_reduce {
    paramter_test_mappping_enable='true'
    component_paramter_test_mappping_enable='true'
    c2t_plus_p2t_reduce
}

echo "parameter = $parameter_entry"
echo "white_list_check_enable is $white_list_check_enable"
echo -n "c2t_reduce "
c2t_reduce

echo -n "c2t_plus_p2t_reduce "
c2t_plus_p2t_reduce

echo -n "c2t_plus_p2t_plus_p2c_reduce "
c2t_plus_p2t_plus_p2c_reduce
#c2t_plus_p2t_plus_p2c_reduce > ~/reconf_test_gen/reduction/"$(echo $parameter_entry | awk '{print $1}')"
