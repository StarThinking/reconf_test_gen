# structure final
rm *txt*; for i in $(grep -oP "node-[0-9]{1,2}$" /etc/hosts | sed 's/node-//g' | sort -n); do tar zxvf $i.tar.gz ; done; rm *.tar.gz; mkdir component; mkdir parameter; mkdir ultimate; mv *-component-meta.txt component; mv *-parameter-meta.txt parameter; mv *-ultimate-meta.txt ultimate; mkdir final; mv * final

# sanity check
grep -rn ERROR * | grep 'sanity check failed' | awk -F '-component-meta.txt' '{print $1}' | sort -u
grep -rn 'msx-rc 0' | wc -l; grep -rn 'msx-rc 1' | wc -l; 

# identified result
cd final/component/;
#grep registerMyComponent * | awk -F '-component-meta.txt' '{print $1"-component-meta.txt"}' | sort -u | while read line; do echo $line; ~/reconf_test_gen/identify.sh $line 1; echo ""; done > result.txt; mkdir ../identify; mv *-identify-*.txt ../identify; cd ../identify; cat *-identify-can.txt | sort -u > all_can.txt; cat *-identify-cannot.txt | sort -u > all_cannot.txt; comm -13 all_can.txt all_cannot.txt > unique_cannot.txt
ls | while read line; do echo $line; ~/reconf_test_gen/identify.sh $line 1; echo ""; done > result.txt; mkdir ../identify; mv *-identify-*.txt ../identify; 
#cd ../identify; cat *-identify-can.txt | sort -u > all_can.txt; cat *-identify-cannot.txt | sort -u > all_cannot.txt; comm -13 all_can.txt all_cannot.txt > unique_cannot.txt

# filter because the tests are generated wrong
ls | while read i; do para=$(echo $i | awk -F '%|_' '{print $1}'); test=$(echo $i | awk -F '%|_' '{print $2}'); if [ "$(find ~/vm_images/the_final/test_gen/identity_link/ -name "$test"-identify-cannot.txt | xargs grep ^"$para"$)" != "" ]; then echo $i; fi; done | tee hahaha.txt

ls | while read i; do para=$(cat $i | head -n 3 | tail -n 1 | awk -F 'h_list: |@@@' '{print $2}'); test=$(cat $i | head -n 2 | tail -n 1 | awk -F 'u_test: ' '{print $2}'); if [ "$(find ~/vm_images/the_final/test_gen/identity_link/ -name "$test"-identify-cannot.txt | xargs grep ^"$para"$)" != "" ]; then echo $i; fi; done | tee hahaha.txt

# under final/component/
cat result.txt | grep '% can' | awk '{print $NF}' | sort -n > distri.txt

echo "avg:"; awk '{ total += $1; count++ } END { print total/count }' distri.txt; echo "50p:"; head -n $(echo "$(cat distri.txt | wc -l) / 2" | bc) distri.txt | tail -n 1;  echo "90p:"; head -n $(echo "scale=0; $(cat distri.txt | wc -l) / 100 * 10" | bc) distri.txt | tail -n 1;  echo "95p:"; head -n $(echo "scale=0; $(cat distri.txt | wc -l) / 100 * 5" | bc) distri.txt | tail -n 1;

echo "avg:"; awk '{ total += $1; count++ } END { print total/count }' distri.txt; echo "50p:"; head -n $(echo "$(cat distri.txt | wc -l) / 2" | bc) distri.txt | tail -n 1



# get hbase main+conf components
grep -rn 'static void main(' | awk -F ':' '{print $1}' | grep .java | grep -v '/test/' | while read line; do if [ "$(grep 'HBaseConfiguration.create' $line)" != "" ]; then echo $line; fi; done

# component init point statistics
grep ' init,' * | awk '{print $2}' | sort | uniq -c | sort -n -r -k1 | awk '{print $1" "$2}'
