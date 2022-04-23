#!/usr/bin/env bash
DISK_LIST=`cat ../Config/performance.py | grep diskList | cut -d "=" -f2 | cut -d "\"" -f2 `
for i in ${DISK_LIST[*]}
    do
        disk=${i}
        pool="p"${i}
        echo "from disk:"${disk}" destroy pool"
        zpool destroy -f ${pool}
    done