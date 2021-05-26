#!/usr/bin/env bash
# 读写磁盘（动态获取）
#filename="/dev/mapper/mpatha:/dev/mapper/mpathb:/dev/mapper/mpathc:/dev/mapper/mpathd:/dev/mapper/mpathe:/dev/mapper/mpathf:/dev/mapper/mpathg:/dev/mapper/mpathh"
filename="/dev/mapper/"`multipath -ll | grep name | awk '{print $1}' | tr '\n' ':' | sed "s!:!:/dev/mapper/!g"`
echo "test disk : "${filename:0:0-13}
# 参数 落盘 使用空间100% 64个线程 运行时间1800S 任务前等待30S
fio -filename=${filename:0:0-13} -direct=1  -thread   -size=100%  -numjobs=64  -time_based -runtime=1800 -startdelay=30 -group_reporting  -ioengine=ioway -bs=block -rw=rwway -name=reportname >> output