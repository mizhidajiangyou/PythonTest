#!/usr/bin/env bash
# IP配置
IP_LIST=("192.168.16.231" "192.168.16.232")
# 本机IP
MY_IP=${IP_LIST[0]}
# 日期
FILE_DATE=`date '+%y%m%d'`
# 脚本地址
VD_FILE="`pwd`"
# VDBENCH目录
VD_HOME="/root/vdbench/"
# 报告目录
VD_OUT="/root/vdbench/vd-output"
# 日志存放目录
VD_LOG="/var/log/vdbench/"
# 日志重定向文件
LOG_FILE="/var/log/vdbench/vd$FILE_DATE.log"
# 密码
MY_PASSWD=password
# 判断IP是否可用
pingIP(){
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

checkIP(){
    for i in ${IP_LIST[*]}
    do
        pingIP $i
    done
    if [ `ip a | grep $MY_IP |wc -l` -eq 1 ];then
        echo "MY_IP is $MY_IP" >> ${LOG_FILE}
    else
        echo "$MY_IP not ok !" >> ${LOG_FILE}
        exit 1
    fi
}


# 根据IP生成客户端名称C-xx
makeClient(){
    for ((i=0;i<${#IP_LIST[*]};i++))
    do
        clientName[$i]="C-`echo ${IP_LIST[$i]} |cut -d '.' -f4`"
        echo $i
    done
}

makeHosts(){
    printf  "%s\n%s\n"  "127.0.0.1    localhost localhost.localdomain " "::1    localhost localhost.localdomain" >  /etc/hosts

    for ((i=0;i<${#IP_LIST[*]};i++))
    do
        hostInfo="${IP_LIST[$i]}    ${clientName[$i]}"
        echo "$hostInfo" >> /etc/hosts
    done
}


# 免密
getPub(){

    expect -c "
        set timeout 3;
        spawn ssh root@$1
        expect {
            \"yes/no\" {send \"yes\r\"; exp_continue;}
            \"password:\" {send \"$MY_PASSWD\r\";}
        }
        expect \"#\"
        send \"yes | ssh-keygen -t rsa -b 2048 -P '' -f /root/.ssh/id_rsa\r\"
        expect \"#\"
        send \"scp /root/.ssh/id_rsa.pub ${MY_IP}:/root/pb-$1\r\"
        expect {
            \"yes/no\" {send \"yes\r\"; exp_continue;}
            \"password:\" {send \"$MY_PASSWD\r\";}
        }
        expect \"#\"
        send \"exit\r\"
        expect eof"

    cat /root/pb-$1 >> /root/.ssh/authorized_keys


}
sendPub(){
    expect -c "
        set timeout 3;
        spawn scp /root/.ssh/authorized_keys root@$1:/root/.ssh
        expect {
            \"yes/no\" {send \"yes\r\"; exp_continue;}
            \"password:\" {send \"$MY_PASSWD\r\";}
        }
        expect eof"
}
run-no(){
    yes | ssh-keygen -t rsa -b 2048 -P "" -f /root/.ssh/id_rsa
    # 完成免密
    for i in ${IP_LIST[*]}
    do
       getPub ${i}
    done
    # echo `cat /root/.ssh/id_rsa.pub` >> /root/.ssh/authorized_keys
    for i in ${IP_LIST[*]}
    do
       sendPub ${i}
    done
    # 修改hosts
    for i in ${IP_LIST[*]}
    do
       scp /etc/hosts root@${i}:/etc
    done

}
ip_main(){

    checkIP
    makeClient
    makeHosts
    run-no
}

ip_main