#!/bin/bash

if [ $# -ne 3 ]; then echo 'the_final_dir the_project the_component'; exit -1; fi

function check_restart {
    project=$1
    component=$2
    logfile=$3
    stopped=0
    restarted=0

    while IFS='\n' read -r line
    do
        if [ "$(echo $line | grep "$project $component stop")" != "" ]; then
            stopped=1
        fi
        if [ "$(echo $line | grep "$project $component init")" != "" ]; then
            if [ $stopped -eq 1 ]; then
                restarted=1
            fi
        fi
    done < "$logfile"

    return $restarted
}

the_final_dir=$1
the_project=$2
the_component=$3

for log in $the_final_dir/*
do
    check_restart $the_project $the_component $log
    ret=$?
    if [ $ret -eq 1 ]; then
        echo $log
    fi
done
