# structure final
for i in $(seq 0 15); do tar zxvf $i.tar.gz ; done; rm *.tar.gz
mkdir component; mkdir parameter; mkdir ultimate; mv *-component-meta.txt component; mv *-parameter-meta.txt parameter; mv *-ultimate-meta.txt ultimate;
mkdir final; mv * final

# get hbase main+conf components
grep -rn 'static void main(' | awk -F ':' '{print $1}' | grep .java | grep -v '/test/' | while read line; do if [ "$(grep 'HBaseConfiguration.create' $line)" != "" ]; then echo $line; fi; done

# component init point statistics
grep ' init,' * | awk '{print $2}' | sort | uniq -c | sort -n -r -k1 | awk '{print $1" "$2}'
