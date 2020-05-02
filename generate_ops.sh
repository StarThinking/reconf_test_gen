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
v1='true'
v2='false'
component_array="$component_project"_components[@]
components=( $(for c in ${!component_array}; do echo $c; done) ) # dynamically create a new array
#echo "Analyzing $component_project's components are ${components[@]}"

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


function get_tests_by_component_project {
    root_dir='/root/reconf_test_gen'
    component_analysis_dir="$root_dir"/"$component_project"/component_analysis/
    cd $component_analysis_dir
    
    for i in *_inited_in_*
    do
        component_proj=$(echo $i | awk -F '_|.txt' '{print $1}')
        if [ "$component_proj" != "$component_project" ]; then echo "wrong $component_proj"; exit -1; fi
            
	component=$(echo $i | awk -F '_|.txt' '{print $2}')
	#if [ "$component" != "$comp" ]; then continue; fi
        
	test_project=$(echo $i | awk -F '_|.txt' '{print $5}')
        
        log_suffix='-component-meta.txt'
        final_component_dir='final/component'
        test_project_tests=$(ls /root/reconf_test_gen/"$test_project"/final/component/ | awk -F "$log_suffix" '{print $1}')
        
        for test in $(cat $i)
        do
    	    found=0
    	    for t in ${test_project_tests[@]}
    	    do
    	        if [ "$test" == "$t" ]; then found=$(( found + 1 )); fi
    	    done
    	    if [ $found -ne 1 ]; then echo 'Error happened when searching $test in $test_project'; exit -1; fi
    	    log="/root/reconf_test_gen/"$test_project"/"$final_component_dir"/"$test""$log_suffix""
    	    init_count $log $component_project $component
    	    rc=$?
	    for parameter in ${parameters[@]}
	    do
	        for init_p in $(seq 1 $rc)
	        do
    	            echo "$parameter $component $v1 $v2 $test_project $test $init_p"
    	            echo "$parameter $component $v2 $v1 $test_project $test $init_p"
 	        done
    	    done
        done
    done
}

get_tests_by_component_project
