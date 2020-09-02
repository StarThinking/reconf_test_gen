#!/bin/bash

IFS=$'\n'
log=$1

rm later.txt raw_cannot.txt raw_can.txt 2> /dev/null
rm cannot.txt raw_can_with_later.txt can.txt 2> /dev/null
rm total.txt 2> /dev/null

cat $log | grep 'can be identified' | awk '{print $2}' | sort -u > raw_can.txt
cat $log | grep 'cannot be identified' | awk '{print $2}' | sort -u > raw_cannot.txt
later_conf=( $(cat $log | grep 'later identified' | awk '{print $2}' | sort -u) )
for c in ${later_conf[@]}; do cat $log | grep 'cannot be identified' | grep $c; done | awk '{print $2}' | sort -u > later.txt

# exclude later from raw cannot
comm -23 raw_cannot.txt later.txt > cannot.txt

# merge raw can with later
cat raw_can.txt later.txt | sort -u > raw_can_with_later.txt

# exclude cannot from can
comm -23 raw_can_with_later.txt cannot.txt > can.txt

# combine can and cannot
cat can.txt cannot.txt | sort -u > total.txt

echo "# raw_can = $(cat raw_can.txt | wc -l)"
echo "# raw_cannot = $(cat raw_cannot.txt | wc -l)"
echo "# later = $(cat later.txt | wc -l)"
echo "# can = $(cat can.txt | wc -l)"
echo "# cannot = $(cat cannot.txt | wc -l)"
if [ $(cat total.txt | wc -l) -ne 0 ] && [ $(cat total.txt | wc -l) -gt 50 ]; then
    echo "% can = $(echo "scale=2; $(cat can.txt | wc -l) * 100 / $(cat total.txt | wc -l)" | bc)"
fi

rm later.txt raw_cannot.txt raw_can.txt 2> /dev/null
rm cannot.txt raw_can_with_later.txt can.txt 2> /dev/null
rm total.txt 2> /dev/null
