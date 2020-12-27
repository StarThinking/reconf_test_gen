#!/bin/bash

file_name=$1
proj=$2

for i in $(cat $file_name); do ./run_mvn_test.sh $proj $i ~/reconf_test_gen/target/; done
