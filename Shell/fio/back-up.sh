#!/usr/bin/env bash
# fc
# 读写磁盘
filename="/dev/mapper/mpatha:/dev/mapper/mpathb:/dev/mapper/mpathc:/dev/mapper/mpathd:/dev/mapper/mpathe:/dev/mapper/mpathf:/dev/mapper/mpathg:/dev/mapper/mpathh"
# 参数 落盘 使用空间100% 64个线程 运行时间1800S 任务前等待30S
fio -filename=${filename} -direct=1  -thread   -size=100%  -numjobs=64  -time_based -runtime=1800 -startdelay=30 -group_reporting  -ioengine=ioway -bs=block -rw=rwway -name=reportname >> output

# iscsi
# 读写磁盘
filename="/dev/sdb:/dev/sdc:/dev/sdd:/dev/sde:/dev/sdf:/dev/sdg:/dev/sdh:/dev/sdi"
# 参数 落盘 使用空间100% 64个线程 运行时间1800S 任务前等待30S
fio -filename=${filename} -direct=1  -thread   -size=100%  -numjobs=64  -time_based -runtime=1800 -startdelay=30 -group_reporting  -ioengine=ioway -bs=block -rw=rwway -name=reportname >> output

# nfs
# 读写文件
filename="/mnt/n10:/mnt/n11:/mnt/n12:/mnt/n13:/mnt/n20:/mnt/n21:/mnt/n22:/mnt/n23"
# 落盘 创建文件为10G*64 运行时间1800S
fio -director=${filename} -direct=1  -thread  -size=10G -numjobs=64 -time_based  -runtime=1800 -group_reporting   -startdelay=30 -ioengine=ioway -rw=rwway -bs=block -name=reportname >> output
