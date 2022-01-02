#!/usr/bin/env bash
# 本脚本用于配置机器间的免密
FILE_DATE=`date '+%y%m%d'`
mkdir -p /var/log/z
LOG_FILE="/var/log/z/z.log.${FILE_DATE}"
IP_LIST=("10.0.24.96" "10.0.24.97" "10.0.24.98" "10.0.24.99")
# 判断IP是否可用
checkip(){
 a=1
 while [ $a -eq 1 ];do
    line=`ping -c 1 -W 1 -s 1 $1 | grep "100% packet loss" | wc -l`
    if [ $line -eq 0 ];then
        echo "ping $1 ok" >> ${LOG_FILE}
        a=0
        return 0
    else
        echo "$1 not ok try again after 3s!" >> ${LOG_FILE}
    fi
        sleep 3
 done
}
# 重启
reStart(){
    ssh $1 << ZTX
    chronyc -a makestep
    sleep 1
    reboot
ZTX
}
# 配置hostname
setHostName(){
    expect << ZTX
    set timeout 3
    spawn ssh root@$1
    expect {
        "*yes/no" { send "yes\r" }
        "*password:" { send "password\r" }
    }
    exit 0
ZTX
}
# 配置IP
