#!/bin/bash

if [ $# -ne 3 ]; then echo 'the_final_dir the_project the_component'; exit -1; fi

the_final_dir=$1
the_project=$2
the_component=$3

for log in $the_final_dir/*
do
    if [ "$(grep "$the_project $the_component init" $log)" != "" ]; then
        echo $log
    fi
done
