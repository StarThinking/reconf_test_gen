#!/bin/bash

for i in *; do cat $i | grep -v ^null$ > $i.tmp; mv $i.tmp $i; done
