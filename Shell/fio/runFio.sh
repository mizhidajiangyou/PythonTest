#!/usr/bin/env bash
# 整合全部类型的fio脚本
d="testDisk"

# 判断参数磁盘名称是否存在
if [ x$d != x ]
then
    disk=$d
    echo "test disk:" $d
else
    echo "error! please enter disk!"
    exit 0
fi

#参数开头若为1，通过软连接测试卷
case ${disk:0:1} in

s)
    filename="/dev/"${disk}
    ;;
a)
    disk=${disk:1}
    cd /dev/zvol/p${disk}
    filename="/dev/"`ls -al | grep v | awk '{print $11}'|cut -d "/" -f3 | tr '\n' ':' | sed "s!:!:/dev/!g"`
    filename=${filename:0:0-6}
    echo "test zvol : "${filename}
    cd -
    ;;
*)
    echo "error! please enter true disk! first string is a for test zvol"
    exit 0
    ;;
esac


fio -filename=${filename} -direct=1  -thread   -size=100%  -numjobs=64  -time_based -runtime=1800 -startdelay=30 -group_reporting  -ioengine=ioway -bs=block -rw=rwway -name=reportname >> output