#!/bin/bash

IFS=$'\n'

if [ $# -ne 1 ]; then echo 'wrong: [test_name]'; exit -1; fi

test_name=$1
component_log="$test_name"-component-meta.txt
parameter_log="$test_name"-parameter-meta.txt

num=$(cat "$component_log" | grep 'conf with hashCode' | wc -l)
component_conf_hc_array=( $(cat "$component_log" | grep 'conf with hashCode' | awk '{print $(NF-2)}') )
component_name_array=( $(cat "$component_log" | grep 'conf with hashCode' | awk '{print $NF}') )
#for i in $(seq 0 $(( num - 1 )))
#do
#    echo "hc: ${component_conf_hc_array[$i]}"
#    echo "name: ${component_name_array[$i]}"
#done

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

parameter_log_line_element=6
#compo_uniq=( $(echo ${component_name_array[@]} | tr ' ' '\n' | sort -u) )
#compo_uniq+=('OtherComponent')

rm ./tmp/*

for line in $(cat $parameter_log)
do
    element_num=$(echo $line | awk '{print NF}')
    if [ $element_num -ne $parameter_log_line_element ]; then continue; fi
    para=$(echo $line | awk '{print $2}')
    conf_hc=$(echo $line | awk '{print $NF}')
    component=$(get_component_name_by_conf_hc $conf_hc)
    echo "$para" >> ./tmp/"$component"
done

# sort
for i in ./tmp/*
do
    cat $i | sort -u > ./"$i".tmp
    mv ./"$i".tmp $i
done
