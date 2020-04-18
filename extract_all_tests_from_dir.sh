#!/bin/bash

if [ $# -ne 1 ]; then echo 'wrong'; exit -1; fi
the_dir=$1

tmp_file=/root/tmp_listener.txt
if [ -f $tmp_file ] ; then rm $tmp_file; fi
grep -r 'test started' $the_dir | awk -F 'test started ' '{print $2}' > $tmp_file

while IFS=$'\n' read -r line
do 
    if [ "$(echo "$line" | grep :)" != "" ]; then 
	echo "$line" | awk -F ':' '{print $1}' | sed 's/$/:*]/g'
    else
	echo "$line"    
    fi
done < $tmp_file 
rm $tmp_file
