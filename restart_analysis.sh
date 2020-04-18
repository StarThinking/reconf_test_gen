#!/bin/bash

if [ $# -ne 3 ]; then
    echo 'wrong argument: methodfile component'
    exit -1
fi

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

check_restart $1 $2 $3
echo $?
