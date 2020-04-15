#!/bin/bash

cp /root/hadoop-3.2.1-src/hadoop-common-project/hadoop-common/target/*.jar /root/.m2/repository/org/apache/hadoop/hadoop-common/3.2.1/
ls -la /root/.m2/repository/org/apache/hadoop/hadoop-common/3.2.1/

# HDFS
cp /root/hadoop-3.2.1-src/hadoop-hdfs-project/hadoop-hdfs/target/*.jar /root/.m2/repository/org/apache/hadoop/hadoop-hdfs/3.2.1/
ls -la /root/.m2/repository/org/apache/hadoop/hadoop-hdfs/3.2.1/

# Yarn
cp /root/hadoop-3.2.1-src/hadoop-yarn-project/hadoop-yarn/hadoop-yarn-server/hadoop-yarn-server-tests/target/*.jar /root/.m2/repository/org/apache/hadoop/hadoop-yarn-server-tests/3.2.1/
ls -la /root/.m2/repository/org/apache/hadoop/hadoop-yarn-server-tests/3.2.1/

# HBase HMaster HRegionServer
cp /root/hadoop-3.2.1-src/hbase-2.2.4/hbase-server/target/*.jar /root/.m2/repository/org/apache/hbase/hbase-server/2.2.4/
ls -la /root/.m2/repository/org/apache/hbase/hbase-server/2.2.4/

# MapReduce
cp /root/hadoop-3.2.1-src/hadoop-mapreduce-project/hadoop-mapreduce-client/hadoop-mapreduce-client-jobclient/target/*.jar /root/.m2/repository/org/apache/hadoop/hadoop-mapreduce-client-jobclient/3.2.1/
ls -la /root/.m2/repository/org/apache/hadoop/hadoop-mapreduce-client-jobclient/3.2.1/
