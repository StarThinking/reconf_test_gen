#!/bin/bash

if [ $# != 1 ]; then echo 'wrong'; exit -1; fi

# yarn
the_project=$1

for sub in $(cat /root/reconf_test_gen/"$yarn"/sub_projects.txt)
do
    echo $sub
    cd $sub
    #mvn test > mvn_result.txt
    find . -name *output.txt | awk -F './target/surefire-reports/' '{print $2}' | awk -F '-output.txt' '{print $1}' | sort -u > all_classes.txt
done

#
# for i in $(find . -name all_classes.txt); do copy_file=$(echo $i | sed 's#/#%#g' | sed 's/^..//'); echo $copy_file; cp $i $copy_file; done
# for i in $(find . -name mvn_result.txt); do copy_file=$(echo $i | sed 's#/#%#g' | sed 's/^..//'); echo $copy_file; cp $i $copy_file; done
