1. Both Hive and Hadoop use the listener in hadoop-common: their root pom.xml surefire plugin defines listener.
2. Hadoop-common (test) is additionally inserted in Hive root pom.xml.
3. Since all HDFS/YARN/MR/HADOOP-TOOLS are already depending on hadoop-common (test), we don't need to insert it.

