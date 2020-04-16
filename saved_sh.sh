for i in org*; do if [ "$(grep msx $i | grep -v msx-listener)" == "" ]; then echo $i; fi; done | sort -u > ../no_init_classes.txt

IFS=$'\n'; for i in $(cat all_tests.txt); do class=$(echo $i | awk -F '#' '{print $1}'); if [ "$(grep ^"$class"$ ./no_init_classes.txt)" == "" ] ; then echo $i; fi; done > raw_init_tests.txt
