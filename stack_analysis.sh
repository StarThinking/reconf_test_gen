#!/bin/bash

IFS=$'\n'
if [ $# -ne 2 ]; then echo 'wrong'; exit -1; fi

stack_log=$1
parameter_log=$2

# entry lines
entry_lines=( $(grep -n 'msx-stack tid =' $stack_log | awk -F ':' '{print $1}') )

# tids
tids=( $(grep 'msx-stack tid =' $stack_log | awk '{print $NF}') )

# init tid_component, index is tid
tid_component=()
for t in ${tids[@]}
do
    tid_component[$t]='Other'
done

components+=('DataNode')
path_prefixs+=('org.apache.hadoop.hdfs.server.datanode.')
components+=('NameNode')
path_prefixs+=('org.apache.hadoop.hdfs.server.namenode.')
component_num=${#components[@]}
#for index in $(seq 0 $(( component_num - 1 )))
#do
#    echo "${components[$index]} with prefix ${path_prefixs[$index]}"
#done

function component_analysis {
    tid=$1
    begin_line=$2
    end_line=$3
    component=''

    #echo "tid = $tid"
    # iterate from bottom to top
    # infer the component by the first matching path prefix
    for line in $(seq $end_line -1 $begin_line)
    do
        stack_content=$(sed -n "$line"p $stack_log)
        for index in $(seq 0 $(( component_num - 1 )))
        do
            prefix=${path_prefixs[$index]}
            component=${components[$index]}
            if [ "$(echo $stack_content | grep "$prefix")" != "" ]; then
                #echo "$tid is $component $stack_content"
                tid_component[$tid]=$component
                return
            fi
        done
    done
    return
}

for entry_line in ${entry_lines[@]}
do
    tid=$(sed -n "$entry_line"p $stack_log | awk '{print $NF}')
    
    length_line=$(( entry_line + 1 ))
    stack_len=$(sed -n "$length_line"p $stack_log | awk '{print $NF}')

    begin_line=$(( length_line + 1 ))
    end_line=$(( length_line + stack_len ))
    
    #echo "tid $tid stack begins at $begin_line ends at $end_line"
    component_analysis $tid $begin_line $end_line
done

# print result of tid_component
#for index in $(seq 0 $(( ${#tid_component[@]} - 1 )))
#do
#    if [ "${tid_component[$index]}" != "" ]; then
#        echo "${tid_component[$index]} $index"
#    fi
#done

paramter_tid=( $(cat $parameter_log | awk -F ',' '{print $(NF-2)," ",$(NF-1)}' | sort -u) )
for para_tid in ${paramter_tid[@]}
do
    para=$(echo $para_tid | awk '{print $1}')
    tid=$(echo $para_tid | awk '{print $2}')
    echo "$para is used by thread $tid"
    # try to find tid in tids
    found=0
    for t in ${tids[@]}
    do
        if [ "$tid" == "" ] || [ "$t" == "" ]; then continue; fi
        if [ $tid -eq $t ]; then
            the_component=${tid_component[$tid]}
            echo "$para is used by component $the_component" >> tmp/"$the_component".txt
            found=1
            break
        fi
    done
    if [ $found -eq 0 ]; then echo "$para is used by other component" >> tmp/other_component.txt; fi
done

exit 0
