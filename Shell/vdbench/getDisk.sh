#!/usr/bin/env bash
read -p "enter size: " Size
diskName=`multipath -ll | grep -B 1 ${Size}G | grep mpath | awk '{print $1}'`
