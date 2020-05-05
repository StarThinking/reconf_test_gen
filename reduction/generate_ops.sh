#!/bin/bash

IFS=$'\n'

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

if [ $# -lt 2 ]; then echo 'wrong: [component_project] [parameter...]'; exit -1; fi
component_project=$1
shift 1
parameters=( "$@" )

v1='v1'
v2='v2'
component_array="$component_project"_components[@]
components=( $(for c in ${!component_array}; do echo $c; done) ) # dynamically create a new array
op_count=0 # global
root_dir='/root/reconf_test_gen'

function init_count() {
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
function para_used_in_test {
    log_file=$1
    parameter=$2

    if [ "$paramter_test_mappping_enable" == "false" ]; then return 1; fi

    used=0
    if [ "$(grep $parameter $log_file)" != "" ]; then used=1; fi
    return $used
}

function get_tests_by_component_project {
    parameter=$1
    component=$2
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
	    para_used_in_test $parameter_log $parameter
	    p_used=$?
	    if [ $p_used -eq 0 ]; then continue; fi
	    for init_p in $(seq 1 $init_point_num)
	    do
    	        echo "$parameter $component $v1 $v2 $test_project $test $init_p"
    	        echo "$parameter $component $v2 $v1 $test_project $test $init_p"
	        #op_count=$(( op_count + 2 ))
 	    done
        done
    done
}

function c2t_reduce {
    echo -n "c2t_reduce: "
    op_count=0
    paramter_test_mappping_enable='false'
    para='dummy'

    for compo in ${components[@]}
    do
        get_tests_by_component_project $para $compo
    done
    para_num=${#parameters[@]}
    op_count=$(( op_count * para_num ))
    echo $op_count
}

function c2t_plus_p2t_reduce {
    echo -n "c2t_plus_p2t_reduce: "
    op_count=0
    paramter_test_mappping_enable='true'
    for para in ${parameters[@]}
    do
        for compo in ${components[@]}
        do
            get_tests_by_component_project $para $compo
        done
    done
    #echo $op_count
}

#c2t_reduce

c2t_plus_p2t_reduce
