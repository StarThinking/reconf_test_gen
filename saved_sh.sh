for i in org*; do if [ "$(cat $i | grep "msx-reconfagent" | grep -v "reconf_vvmode=none" | grep -v "creating")" == "" ]; then echo $i; fi; done | sort -u > ../no_init_classes.txt

../extract_all_tests_from_dir.sh ./all_classes_hacked | sort -u

IFS=$'\n'; for i in $(cat all_tests.txt); do class=$(echo $i | awk -F '#' '{print $1}'); if [ "$(grep ^"$class"$ ./no_init_classes.txt)" == "" ] ; then echo $i; fi; done > raw_init_tests.txt

for i in $(seq 0 19); do docker container stop hadoop-$i; docker container rm hadoop-$i; done; for i in $(seq 0 19); do docker run -d -it --name hadoop-$i sixiangma/reconf_parameter:v1.9.conf ; done; rm nohup.out; ./clean_update_all_container.sh 19; rm task.txt; git pull

# for classes
./docker_fetch_result.sh; for i in org*.txt; do grep msx $i | grep -v msx-conf > $(echo $i | awk -F '-output.txt' '{print $1}'); done; rm *-output.txt; ls | grep org | wc -l; cat task.txt | wc -l

# for tests
./docker_fetch_result.sh; for i in org*.txt; do ./compress.sh $i; done | wc -l; rm *-output.txt; ls | grep component-meta.txt | wc -l; cat task.txt | wc -l

# soot find classpath
for i in hdfs yarn mapreduce; do find /root/hadoop-3.2.1-src/hadoop-"$i"-project/ -name *.jar | grep -v -e '/lib' -e '/share' -e '-javadoc.jar' -e '-sources.jar' -e '-tests.jar' > ~/reconf_test_gen/"$i"/soot_path/"$i"_classpath.txt; done

# soot find proc dir
for i in hdfs hbase yarn mapreduce hadoop-tools; do echo $i; cd $i/final/component/; for i in *; do tail -n 1 $i; done | grep 1 | wc -l; echo 'out of'; ls | wc -l; cd -; done

# find classpath
for i in hdfs yarn mapreduce; do find /root/hadoop-3.2.1-src/hadoop-"$i"-project/ -name *.jar | grep -v -e '/lib' -e '/share' -e '-javadoc.jar' -e '-sources.jar' -e '-tests.jar' > ~/reconf_test_gen/"$i"/soot_path/"$i"_classpath.txt; done

# find proc dir
find /root/hbase-2.2.4/ -name classes > ~/reconf_test_gen/hbase/proc_dir.txt

# find component full name
for i in ResourceManager NodeManager ApplicationHistoryServer; do prefix=$(grep ^"package " $(find . -name "$i".java) | awk -F ' ' '{print $2}' | sed 's/.$//g'); echo "$prefix"."$i";  done

java ReadXMLFile hbase/hbase-default.xml | awk -F ' ' '{if($2 == "true" || $2 == "false") print $1}' | sort -u > boolean_xml.txt
