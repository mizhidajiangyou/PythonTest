#!/usr/bin/env bash
# 读写文件
filename="/mnt/n10:/mnt/n11:/mnt/n12:/mnt/n13:/mnt/n20:/mnt/n21:/mnt/n22:/mnt/n23"
# 落盘 创建文件为10G*64 运行时间1800S
fio -director=${filename} -direct=1  -thread  -size=10G -numjobs=64 -time_based  -runtime=1800 -group_reporting   -startdelay=30 -ioengine=ioway -rw=rwway -bs=block -name=reportname >> output
