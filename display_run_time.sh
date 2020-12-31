#!/bin/bash

proj=$1
cat "$proj".txt | awk '{print $1}' | awk '{s+=$1} END {printf "%.0f\n", s}'; cat "$proj".txt | awk '{print $2}' | awk '{s+=$1} END {printf "%.0f\n", s}'
