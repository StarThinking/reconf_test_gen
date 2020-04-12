#!/bin/bash

cp /root/hadoop-3.2.1-src/hadoop-common-project/hadoop-common/target/hadoop-common-3.2.1.jar /root/.m2/repository/org/apache/hadoop/hadoop-common/3.2.1/

# HDFS
cp /root/hadoop-3.2.1-src/hadoop-hdfs-project/hadoop-hdfs/target/hadoop-hdfs-3.2.1.jar /root/.m2/repository/org/apache/hadoop/hadoop-hdfs/3.2.1/

# Yarn
cp /root/hadoop-3.2.1-src/hadoop-yarn-project/hadoop-yarn/hadoop-yarn-server/hadoop-yarn-server-tests/target/hadoop-yarn-server-tests-3.2.1-tests.jar /root/.m2/repository/org/apache/hadoop/hadoop-yarn-server-tests/3.2.1/

# HBase HMaster HRegionServer
cp /root/hbase-2.2.4/hbase-server/target/hbase-server-2.2.4.jar /root/.m2/repository/org/apache/hbase/hbase-server/2.2.4/
cp /root/hbase-2.2.4/hbase-server/target/hbase-server-2.2.4-tests.jar /root/.m2/repository/org/apache/hbase/hbase-server/2.2.4/
