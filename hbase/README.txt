root@node-9:~/reconf_test_gen/hbase# diff 22.txt all_tests.txt
2732a2733
> org.apache.hadoop.hbase.regionserver.TestAtomicOperation#testAppendWithNonExistingFamily
3029d3029
< org.apache.hadoop.hbase.regionserver.TestHStoreFile#testMultipleTimestamps
3383d3382
< org.apache.hadoop.hbase.regionserver.TestStripeStoreFileManager#testGetFilesForGetAndScan
3385d3383
< org.apache.hadoop.hbase.regionserver.TestStripeStoreFileManager#testLoadFilesWithBadStripe
3905a3904
> org.apache.hadoop.hbase.rsgroup.TestRSGroupsBasics#testClearDeadServers
4033d4031
< org.apache.hadoop.hbase.security.visibility.TestVisibilityLabelsWithACL#testLabelsTableOpsWithDifferentUsers
