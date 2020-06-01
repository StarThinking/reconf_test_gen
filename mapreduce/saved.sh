# genrate jar_component.txt
# mapreduce
for comp in $(cat ~/reconf_test_gen/mapreduce/all_components.txt); do for j in $(find ~/hadoop-3.2.1-src/hadoop-mapreduce-project/target/hadoop-mapreduce-3.2.1/share/hadoop/mapreduce -name '*.jar'); do res="$(jar tf $j | grep $comp)"; if [ "$res" != "" ]; then echo "$j $comp"; fi; done; done | grep -v /sources/ > jar_component.txt

# hdfs
for comp in $(cat  ~/reconf_test_gen/hdfs/all_components.txt); do for j in $(find ~/hadoop-3.2.1-src/hadoop-hdfs-project/ -name '*.jar' | grep /share); do res="$(jar tf $j | grep $comp)"; if [ "$res" != "" ]; then echo "$j $comp"; fi; done; done | grep -v /sources/

# generate jar_override.txt
IFS=$'\n'; for line in $(cat jar_component.txt); do jar_path="$(echo $line | awk '{print $1}')"; component="$(echo $line | awk '{print $2}')"; jar_name="$(echo $jar_path | awk -F '/' '{print $NF}')"; echo "$jar_name $jar_path"; done | sort -u > jar_override.txt

# perform jar override
IFS=$'\n'; for line in $(cat jar_override.txt); do jar_name="$(echo $line | awk '{print $1}')"; jar_path="$(echo $line | awk '{print $2}')"; mvn_jar_path_num=$(find /root/.m2/ -name $jar_name | wc -l); mvn_jar_path=$(find /root/.m2/ -name $jar_name); if [ $mvn_jar_path_num -ne 1 ]; then echo "ERROR: $jar_name"; exit -1; else echo "use $jar_path to override $mvn_jar_path"; cp $jar_path $mvn_jar_path; fi; done
