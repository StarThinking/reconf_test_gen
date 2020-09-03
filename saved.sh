# structure final
rm *txt*; for i in $(grep -oP "node-[0-9]{1,2}$" /etc/hosts | sed 's/node-//g' | sort -n); do tar zxvf $i.tar.gz ; done; rm *.tar.gz; mkdir component; mkdir parameter; mkdir ultimate; mv *-component-meta.txt component; mv *-parameter-meta.txt parameter; mv *-ultimate-meta.txt ultimate; mkdir final; mv * final

# sanity check
grep -rn ERROR * | grep 'contains internal' | awk -F '-component-meta.txt' '{print $1}' | sort -u

# identified result
cd final/component/;
grep registerMyComponent * | awk -F '-component-meta.txt' '{print $1"-component-meta.txt"}' | sort -u | while read line; do echo $line; ~/reconf_test_gen/identify.sh $line 1; echo ""; done > result.txt; mkdir ../identify; mv *-identify-*.txt ../identify; cd ../identify; cat *-identify-can.txt | sort -u > all_can.txt; cat *-identify-cannot.txt | sort -u > all_cannot.txt; comm -13 all_can.txt all_cannot.txt > unique_cannot.txt

cat result.txt | grep '% can' | awk '{print $NF}' | sort -n > distri.txt
awk '{ total += $1; count++ } END { print total/count }' distri.txt 

# get hbase main+conf components
grep -rn 'static void main(' | awk -F ':' '{print $1}' | grep .java | grep -v '/test/' | while read line; do if [ "$(grep 'HBaseConfiguration.create' $line)" != "" ]; then echo $line; fi; done

# component init point statistics
grep ' init,' * | awk '{print $2}' | sort | uniq -c | sort -n -r -k1 | awk '{print $1" "$2}'
