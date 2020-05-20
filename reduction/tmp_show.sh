#!/bin/bash

proj='yarn'

n1=$(for i in $(cat "$proj"_boolean_prune_num/c2t_reduce.txt); do echo $i; done | paste -sd+ | bc)
echo $n1
echo 1.0

n2=$(for i in $(cat "$proj"_boolean_prune_num/c2t_plus_p2t_reduce.txt); do echo $i; done | paste -sd+ | bc)
echo $n2
echo "scale=3; $n2 / $n1" | bc

n3=$(for i in $(cat "$proj"_boolean_prune_num/c2t_plus_p2t_plus_p2c_reduce.txt); do echo $i; done | paste -sd+ | bc)
echo $n3
echo "scale=3; $n3 / $n1" | bc
