#!/bin/bash

IFS=$'\n'

if [ $# -ne 2 ]; then echo 'wrong: [dir] [test_name]'; exit -1; fi

dir=$1
output_log=$2
test_name=$(echo $output_log | awk -F '-output.txt' '{print $1}')
component_log="$dir"/"$test_name"-component-meta.txt
parameter_log="$dir"/"$test_name"-parameter-meta.txt

if [ ! -f $component_log ] || [ ! -f $parameter_log ]; then echo 'no component_log or parameter_log'; exit 0; fi

num=$(cat "$component_log" | grep 'conf with hashCode' | wc -l)
component_conf_hc_array=( $(cat "$component_log" | grep 'conf with hashCode' | awk '{print $(NF-2)}') )
component_name_array=( $(cat "$component_log" | grep 'conf with hashCode' | awk '{print $NF}') )

declare -A hashmap

for i in $(seq 0 $(( num - 1 )))
do
    hc=${component_conf_hc_array[$i]}
    name=${component_name_array[$i]}
    hashmap["$hc"]="$name"
    #echo "hc: ${component_conf_hc_array[$i]}"
    #echo "name: ${component_name_array[$i]}"
done

function get_component_name_by_conf_hc {    
    hc=$1
    index=-1
    for i in $(seq 0 $(( num - 1 )))
    do
        if [ ${component_conf_hc_array[$i]} -eq $hc ]; then
	    index=$i
	    break
	fi
    done
    if [ $index -eq -1 ] ;then
	echo "OtherComponent"
    else
        echo "${component_name_array[$index]}"."$index"
    fi
}

function main {
    parameter_log_line_element=9
    
    for line in $(cat $parameter_log)
    do
        element_num=$(echo $line | awk '{print NF}')
        if [ $element_num -ne $parameter_log_line_element ]; then continue; fi
        para=$(echo $line | awk '{print $3}')
	conf_hc=$(echo $line | awk '{print $(NF-2)}')
	returnValue=$(echo $line | awk '{print $(NF)}')
	if [ "$returnValue" == "null" ]; then continue; fi
        #component=$(get_component_name_by_conf_hc $conf_hc)
        component=${hashmap["$conf_hc"]}
	if [ "$component" == "" ]; then
	    echo "$para OtherComponent $returnValue"
        else
            echo "$para $component $returnValue"
	fi
    done
}

main | sort -u | sort -k1 -k2 > ./"$test_name"-ultimate-meta.txt
