#!/bin/bash


# Hadoop Common
## Configuration (Optional)
cp /root/reconf_test_gen/lib/hadoop-common-3.2.1.jar /root/.m2/repository/org/apache/hadoop/hadoop-common/3.2.1/

## Listener
cp /root/hadoop-3.2.1-src/hadoop-common-project/hadoop-common/target/*.jar /root/.m2/repository/org/apache/hadoop/hadoop-common/3.2.1/

ls -la /root/.m2/repository/org/apache/hadoop/hadoop-common/3.2.1/ | grep "jar"$
echo ''

# HDFS
cp /root/hadoop-3.2.1-src/hadoop-hdfs-project/hadoop-hdfs/target/*.jar /root/.m2/repository/org/apache/hadoop/hadoop-hdfs/3.2.1/

ls -la /root/.m2/repository/org/apache/hadoop/hadoop-hdfs/3.2.1/ | grep "jar"$
echo ''

# Yarn
cp /root/hadoop-3.2.1-src/hadoop-yarn-project/hadoop-yarn/hadoop-yarn-server/hadoop-yarn-server-tests/target/*.jar /root/.m2/repository/org/apache/hadoop/hadoop-yarn-server-tests/3.2.1/

ls -la /root/.m2/repository/org/apache/hadoop/hadoop-yarn-server-tests/3.2.1/ | grep "jar"$
echo ''

# MapReduce
cp /root/hadoop-3.2.1-src/hadoop-mapreduce-project/hadoop-mapreduce-client/hadoop-mapreduce-client-jobclient/target/*.jar /root/.m2/repository/org/apache/hadoop/hadoop-mapreduce-client-jobclient/3.2.1/

ls -la /root/.m2/repository/org/apache/hadoop/hadoop-mapreduce-client-jobclient/3.2.1/ | grep "jar"$
echo ''


# HBase
## Configuration (Optional)
cp /root/reconf_test_gen/lib/hadoop-common-2.8.5.jar /root/.m2/repository/org/apache/hadoop/hadoop-common/2.8.5/

ls -la /root/.m2/repository/org/apache/hadoop/hadoop-common/2.8.5/ | grep "jar"$
echo ''

## HBaseListener
cp /root/hbase-2.2.4/hbase-common/target/*.jar /root/.m2/repository/org/apache/hbase/hbase-common/2.2.4

ls -la /root/.m2/repository/org/apache/hbase/hbase-common/2.2.4/ | grep "jar"$
echo ''

## HBase Server
cp /root/hbase-2.2.4/hbase-server/target/*.jar /root/.m2/repository/org/apache/hbase/hbase-server/2.2.4/

ls -la /root/.m2/repository/org/apache/hbase/hbase-server/2.2.4/ | grep "jar"$
echo ''

## HDFS Yarn MapReduce
cp /root/hadoop-2.8.5-src/hadoop-hdfs-project/hadoop-hdfs/target/*.jar /root/.m2/repository/org/apache/hadoop/hadoop-hdfs/2.8.5/
ls -la /root/.m2/repository/org/apache/hadoop/hadoop-hdfs/2.8.5/ | grep "jar"$
echo ''

cp /root/hadoop-2.8.5-src/hadoop-yarn-project/hadoop-yarn/hadoop-yarn-server/hadoop-yarn-server-tests/target/*.jar /root/.m2/repository/org/apache/hadoop/hadoop-yarn-server-tests/2.8.5/
ls -la /root/.m2/repository/org/apache/hadoop/hadoop-yarn-server-tests/2.8.5/ | grep "jar"$
echo ''

cp /root/hadoop-2.8.5-src/hadoop-mapreduce-project/hadoop-mapreduce-client/hadoop-mapreduce-client-jobclient/target/*.jar /root/.m2/repository/org/apache/hadoop/hadoop-mapreduce-client-jobclient/2.8.5/
ls -la /root/.m2/repository/org/apache/hadoop/hadoop-mapreduce-client-jobclient/2.8.5/ | grep "jar"$
echo ''
