#!/bin/bash

#for proj in hdfs mapreduce yarn hbase hive; do find $(cat $proj/project_root_dir.txt) -name pom.xml | sed -e "s/pom.xml$//g" | sort | sed '1d' > $proj/all_pom_xml.txt; done

for proj in hdfs mapreduce yarn hbase hive; do find $(cat $proj/project_root_dir.txt) -name pom.xml | sed -e "s/pom.xml$//g" | sort | sed '1d'; done
