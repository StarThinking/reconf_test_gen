# run reconf_test dispatcher distributedly
proj='hdfs'; for i in $(grep -oP "node-[0-9]{1,2}$" /etc/hosts | sed 's/node-//g' | sort -n); do ssh node-$i "rm ~/nohup.txt; nohup ~/reconf_test_gen/dispatcher.sh $proj > nohup.txt &" & pids[$i]=$!; done; for p in ${pids[@]}; do wait $p; echo "$p is done"; done

for i in $(grep -oP "node-[0-9]{1,2}$" /etc/hosts | sed 's/node-//g' | sort -n); do ssh node-$i "rm ~/reconf_test_gen/target/*.txt; ~/parameter_test_controller/container_utility_sh/docker_fetch_result.sh .txt ~/reconf_test_gen/target/ ~/reconf_test_gen/target/"; cd ~/reconf_test_gen/target/; for l in ./*; do ~/reconf_test_gen/compress.sh $l; done; scp node-$i:~/reconf_test_gen/target/*.txt .; done


for i in org*; do if [ "$(cat $i | grep "msx-reconfagent" | grep -v "reconf_vvmode=none" | grep -v "creating")" == "" ]; then echo $i; fi; done | sort -u > ../no_init_classes.txt

../extract_all_tests_from_dir.sh ./all_classes_hacked | sort -u

IFS=$'\n'; for i in $(cat all_tests.txt); do class=$(echo $i | awk -F '#' '{print $1}'); if [ "$(grep ^"$class"$ ./no_init_classes.txt)" == "" ] ; then echo $i; fi; done > raw_init_tests.txt

for i in $(seq 0 19); do docker container stop hadoop-$i; docker container rm hadoop-$i; done; for i in $(seq 0 19); do docker run -d -it --name hadoop-$i sixiangma/reconf_parameter:v1.9.conf ; done; rm nohup.out; ./clean_update_all_container.sh 19; rm task.txt; git pull

# for classes
./docker_fetch_result.sh; for i in org*.txt; do grep msx $i | grep -v msx-conf > $(echo $i | awk -F '-output.txt' '{print $1}'); done; rm *-output.txt; ls | grep org | wc -l; cat task.txt | wc -l

# for tests
./docker_fetch_result.sh; for i in org*.txt; do ./compress.sh $i; done | wc -l; rm *-output.txt; ls | grep component-meta.txt | wc -l; cat task.txt | wc -l

java ReadXMLFile hbase/hbase-default.xml | awk -F ' ' '{if($2 == "true" || $2 == "false") print $1}' | sort -u > boolean_xml.txt

# filter no_type.txt
grep -v .host$ | grep -v .url$ | grep -v .address$ | grep -v .classpath$ | grep -v .classes$ | grep -v .class$ | grep -v .path$ | grep -v .file$ | grep -v .root-dir$ | grep -v .provider$ | grep -v .principal$ | grep -v .hostname$ | grep -v .id$

for i in *; do if [ "$(grep 'msx-listener succeed' $i)" == "" ] && [ "$(grep 'msx-listener failed' $i)" == "" ]; then echo $i; fi; done

# find server classes for a componenet
cd OUTER_DIR_FOR_COMPONENT
find COMPONENT_SERVER_CLASS_PATH_PREFIX -name '*.java' | sed 's#/#.#g' | sed 's/^..//g' | sed 's/.java$//g'

# make up list add statement
cat server_classes.txt | sed 's/^/classList.add("/g' | sed 's/$/");/g'


