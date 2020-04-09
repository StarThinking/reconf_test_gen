#!/bin/bash

if [ $# != 1 ]; then echo 'wrong'; exit -1; fi

# yarn mapreduce hdfs
the_project=$1
sub_projects=$(cat /root/reconf_test_gen/"$the_project"/sub_projects.txt)
project_root_dir=$(cat /root/reconf_test_gen/"$the_project"/project_root_dir.txt)

# run mvn test
#for sub in ${sub_projects[@]}
#do
#    echo $sub; cd $sub; mvn test > mvn_result.txt
#done

# get all class names
for sub in ${sub_projects[@]}
do
    cd $sub; find . -name *output.txt | awk -F './target/surefire-reports/' '{print $2}' | awk -F '-output.txt' '{print $1}' | sort -u > all_classes.txt
done
    
# save class names as files
cd $project_root_dir; for i in $(find . -name all_classes.txt); do copy_file=$(echo $i | sed 's#/#%#g' | sed 's/^..//'); echo $copy_file; cp $i $copy_file; done
cd $project_root_dir; for i in $(find . -name mvn_result.txt); do copy_file=$(echo $i | sed 's#/#%#g' | sed 's/^..//'); echo $copy_file; cp $i $copy_file; done
