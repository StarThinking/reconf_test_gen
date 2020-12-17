#!/bin/bash

proj=$1 
for sub in $(cat $proj/all_pom_xml.txt); do echo "run all tests under $sub"; cd $sub; mvn test; cd -; done
