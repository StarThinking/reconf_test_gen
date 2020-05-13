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
