#!/bin/bash

function copy_jar_for_hadoop {
    hadoop_version=$1
    # Hadoop Common, Default Configuration and Reconf Agent
    cp /root/hadoop-"$hadoop_version"-src/hadoop-common-project/hadoop-common/target/*.jar /root/.m2/repository/org/apache/hadoop/hadoop-common/"$hadoop_version"/
    ls -la /root/.m2/repository/org/apache/hadoop/hadoop-common/"$hadoop_version"/ | grep "jar"$
    echo ''
    
    ## Configuration Override (Optional)
    #cp /root/reconf_test_gen/lib/hadoop-common-"$hadoop_version".jar /root/.m2/repository/org/apache/hadoop/hadoop-common/"$hadoop_version"/
    
    # HDFS
    cp /root/hadoop-"$hadoop_version"-src/hadoop-hdfs-project/hadoop-hdfs/target/*.jar /root/.m2/repository/org/apache/hadoop/hadoop-hdfs/"$hadoop_version"/
    ls -la /root/.m2/repository/org/apache/hadoop/hadoop-hdfs/"$hadoop_version"/ | grep "jar"$
    echo ''
   
    if [ "$hadoop_version" == "2.8.5" ]; then return 0; fi
     
    # Yarn
    ## MiniYARNCluster
    cp /root/hadoop-"$hadoop_version"-src/hadoop-yarn-project/hadoop-yarn/hadoop-yarn-server/hadoop-yarn-server-tests/target/*.jar /root/.m2/repository/org/apache/hadoop/hadoop-yarn-server-tests/"$hadoop_version"/
    ls -la /root/.m2/repository/org/apache/hadoop/hadoop-yarn-server-tests/"$hadoop_version"/ | grep "jar"$
    echo ''

    ## nodemanager
    cp /root/hadoop-"$hadoop_version"-src/hadoop-yarn-project/hadoop-yarn/hadoop-yarn-server/hadoop-yarn-server-nodemanager/target/*.jar /root/.m2/repository/org/apache/hadoop/hadoop-yarn-server-nodemanager/"$hadoop_version"/
    ls -la /root/.m2/repository/org/apache/hadoop/hadoop-yarn-server-nodemanager/"$hadoop_version"/ | grep "jar"$
    echo ''
    
    ## resourcemanager
    cp /root/hadoop-"$hadoop_version"-src/hadoop-yarn-project/hadoop-yarn/hadoop-yarn-server/hadoop-yarn-server-resourcemanager/target/*.jar /root/.m2/repository/org/apache/hadoop/hadoop-yarn-server-resourcemanager/"$hadoop_version"/
    ls -la /root/.m2/repository/org/apache/hadoop/hadoop-yarn-server-resourcemanager/"$hadoop_version"/ | grep "jar"$
    echo ''
    
    ## applicationhistoryservice
    cp /root/hadoop-"$hadoop_version"-src/hadoop-yarn-project/hadoop-yarn/hadoop-yarn-server/hadoop-yarn-server-applicationhistoryservice/target/*.jar /root/.m2/repository/org/apache/hadoop/hadoop-yarn-server-applicationhistoryservice/"$hadoop_version"/
    ls -la /root/.m2/repository/org/apache/hadoop/hadoop-yarn-server-applicationhistoryservice/"$hadoop_version"/ | grep "jar"$
    echo ''
    
    # MapReduce
    cp /root/hadoop-"$hadoop_version"-src/hadoop-mapreduce-project/hadoop-mapreduce-client/hadoop-mapreduce-client-jobclient/target/*.jar /root/.m2/repository/org/apache/hadoop/hadoop-mapreduce-client-jobclient/"$hadoop_version"/
    ls -la /root/.m2/repository/org/apache/hadoop/hadoop-mapreduce-client-jobclient/"$hadoop_version"/ | grep "jar"$
    echo ''
}

function copy_jar_for_hbase {
    # HBase 2.2.4
    ## Hbase Common, HBaseListener
    cp /root/hbase-2.2.4/hbase-common/target/*.jar /root/.m2/repository/org/apache/hbase/hbase-common/2.2.4
    ls -la /root/.m2/repository/org/apache/hbase/hbase-common/2.2.4/ | grep "jar"$
    echo ''
    
    ## HBase Server
    cp /root/hbase-2.2.4/hbase-server/target/*.jar /root/.m2/repository/org/apache/hbase/hbase-server/2.2.4/
    ls -la /root/.m2/repository/org/apache/hbase/hbase-server/2.2.4/ | grep "jar"$
    echo ''
} 

copy_jar_for_hadoop "3.2.1"
copy_jar_for_hadoop "2.8.5"
copy_jar_for_hbase

