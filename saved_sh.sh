for i in org*; do if [ "$(grep msx $i | grep -v msx-listener)" == "" ]; then echo $i; fi; done | sort -u > ../no_init_classes.txt

IFS=$'\n'; for i in $(cat all_tests.txt); do class=$(echo $i | awk -F '#' '{print $1}'); if [ "$(grep ^"$class"$ ./no_init_classes.txt)" == "" ] ; then echo $i; fi; done > raw_init_tests.txt

for i in org*.txt; do grep msx $i > $(echo $i | awk -F '-output.txt' '{print $1}'); done

for i in *; do cat $i | awk -F 'msx-' '{print msx $2}' > ../final/$i; done

for i in $(seq 0 19); do docker container stop hadoop-$i; docker container rm hadoop-$i; done; for i in $(seq 0 19); do docker run -d -it --name hadoop-$i sixiangma/reconf_parameter:v0.9.conf ; done; rm nohup.out; ./clean_update_all_container.sh 19; rm task.txt; git pull

# for classes
./docker_fetch_result.sh; for i in org*.txt; do grep msx $i | grep -v msx-conf > $(echo $i | awk -F '-output.txt' '{print $1}'); done; rm *-output.txt; ls | grep org | wc -l; cat task.txt | wc -l

# for tests
./docker_fetch_result.sh; for i in org*.txt; do ./compress.sh $i; done | wc -l; rm *-output.txt; ls | grep component-meta.txt | wc -l; cat task.txt | wc -l
