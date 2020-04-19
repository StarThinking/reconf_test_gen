#!/bin/bash

if [ $# -ne 2 ]; then echo './component_analysis.sh [component_project] used in [testing_project]'; exit -1; fi

component_project=$1
testing_project=$2

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

log_suffix='-component-meta.txt'
final_component_dir='final/component'
root_dir='/root/reconf_test_gen'
final_component_dir="$root_dir"/"$testing_project"/"$final_component_dir"
if [ ! -d $final_component_dir ]; then 
    echo "ERROR: $final_component_dir not existed!"; exit -1
fi
echo "final_component_dir is $final_component_dir"
component_array="$component_project"_components[@]
# dynamically create a new array
components=( $(for c in ${!component_array}; do echo $c; done) )
echo "Analyzing $component_project's components ${components[@]} used in $testing_project"

function check_restart() {
    log_file=$1
    project=$2
    component=$3
    stopped=0
    restarted=0
    while IFS=$'\n' read -r line
    do
	if [ "$line" == "$project $component stop" ]; then
            stopped=1
        fi
        if [ "$line" == "$project $component init" ]; then
	    # component is inited after some stop
	    if [ $stopped -eq 1 ]; then
	        restarted=1
	    fi
	fi
    done < "$log_file"
    return $restarted
}

function check_init() {
    log_file=$1
    project=$2
    component=$3
    inited=0
    while IFS=$'\n' read -r line
    do
	if [ "$line" == "$project $component init" ]; then
            inited=1
	    break
        fi
    done < "$log_file"
    return $inited
}

for component in "${components[@]}"
do
    init_output_file=""$root_dir"/"$component_project"_"$component"_inited_in_"$testing_project".txt"
    restart_output_file=""$root_dir"/"$component_project"_"$component"_restarted_in_"$testing_project".txt"
    if [ -f $init_output_file ] || [ -f $restart_output_file ]; then echo "WARN: output file existed."; exit 0; fi
    cd $final_component_dir
    for component_log in *
    do
	# check init
        check_init "$component_log" "$component_project" "$component"
        if [ $? -eq 1 ]; then
            echo $component_log | awk -F "$log_suffix" '{print $1}' >> $init_output_file
        fi

	# check restart
        check_restart "$component_log" "$component_project" "$component"
        if [ $? -eq 1 ]; then
            echo $component_log | awk -F "$log_suffix" '{print $1}' >> $restart_output_file
        fi
    done
    cd - > /dev/null
done
