#!/bin/bash
# 使用脚本前，请确认防火墙状态
# 该脚本用于生成单/多主机利用vdbench测试性能
# 磁盘型号
BRAND="SEAGATE"
# 脚本模式
MODE=2
# 测试类型
VD_TYPE="FC"
# 测试设备总大小（G）
V_SI=500
# 运行时间
ELAPSED=300
# 等待时间
WARMUP=30
# 暂停时间
PAUSE=30
# 打印时间
INTERVAL=1
# 总行数
ONE_RD_COUNT=`echo $ELAPSED/$INTERVAL+$WARMUP/$INTERVAL+1|bc`
# 线程
THREADS=32
# 随机比例
SEEK=(100 0)
# 块大小
BLOCK=("4K" "1M")
# 读比例
RDPCT=(0 100)
# 文件系统操作
OPERATION=(write read)
# 文件读写方式
FILEIO=(random sequential)
# 文件选择方式
FILESELECT=(random sequential)
# IP
IP_LIST=(`ip a | grep "state UP" -A 3 |awk '$2~/^[0-9]*\./ {print $2}' |awk -F "/" 'NR==1 {print $1}'`)
# 日期
FILE_DATE=`date '+%y%m%d'`
# 脚本地址
VD_FILE="`pwd`/$FILE_DATE/"
# VDBENCH目录
VD_HOME="/root/vdbench/"
# 报告目录
VD_OUT="$VD_FILE/vd-output/"
# 日志存放目录
VD_LOG="$VD_FILE/"
# 日志重定向文件
LOG_FILE="$VD_FILE/vd$FILE_DATE.log"
# 测试项
ALL_TEST_LIST=()
# 测试名
ALL_TEST_LIST_TITLE=()
# 本机IP
MY_IP=${IP_LIST[0]}
# 密码
MY_PASSWD=password
# 使用方法
usage(){
    echo -e "\033[1musage: vdbench.sh [ --help]

    <--brand| --mode| --type| --ip> \n
    [--size| --rdpct| --block| --fileio| --seekpct] \n
    [--runtime| --interval| --warmup | --pause] \n
    [--file| --out| --log| --date] \n
    brand    <string>            disk manufacturer;default SEAGATE
    mode     <1|2|3>             1-all 2-nohup vdbench 3-only pic;default 2
    type      <fc|iscsi|nfs|cifs>      whether which volume type you test;default fc
    ip        <\"ipaddress\">       all ip list which you want to test;default ssh ip
    size      <int>               disk or file size;default 500
    rdpct     <\"array\">           percentage of read ;default \"0 100\"
    block     <\"array\">           test block size ;default \"4k 1M\"
    fileio    <\"array\">           test fileio ;default \"random sequential\"
    seekpct   <\"array\">           test random ratio ;default \"100 0\"
    runtime   <int>               test runtime(s) ;default 300
    interval  <int>               print interval(s) ;default 1
    warmup    <int>               hot start time(s) ;default 30
    pause     <int>               pause time(s) ;default 30
    file      <\"path\">            *.vbd will put in;default pwd
    out       <\"path\">            vdbench out put will put in;default pwd/vd-output
    log       <\"path\">            run logs will put in;default same with file
    date      <date>              date for test ,like 220101;default date '+%y%m%d'



    e.g.
    --mode 1 --type fc --ip \"192.168.8.81 192.168.8.82\" --file \"/root/vdbench/aa\" --out \"/root/vdbench/outa\"

    ...\033[0m"

    exit 1

}
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

# 检查变量正确性
checkVal(){

    # 检测脚本存放目录
    if [ -d $VD_FILE ]
    then
        echo "*vdb will in $VD_FILE" >> ${LOG_FILE}
    else
        mkdir -p $VD_FILE
        echo "mkdir file" >> ${LOG_FILE}
    fi

    # 检测日志存放目录
    if [ -d $VD_LOG ]
    then
        echo "log file in $VD_LOG" >> ${LOG_FILE}
    else
        mkdir -p $VD_LOG
        echo "mkdir log FILE" >> ${LOG_FILE}
    fi

    # 检测vdbench目录
    if [ -d $VD_HOME ]
    then
        echo "vdbench is in $VD_HOME" >> ${LOG_FILE}
    else
        echo "no vdbench！" >> ${LOG_FILE}
        exit 1
    fi

    # 检测java

    if [  `ls /bin | grep -w java |wc -l` -eq 0 ]
    then
        echo "no java！" >> ${LOG_FILE}
        exit 1
    else
        echo "`ls /bin | grep -w java`" >> ${LOG_FILE}
        echo "java is good" >> ${LOG_FILE}

    fi

    # 检测IP是否可用
    checkIP

    #
}


getTestListB(){
    for i in ${BLOCK[*]}
    do
        for j in ${SEEK[*]}
        do
            for k in ${RDPCT[*]}
            do
                #设定参数
                wd="xfersize=${i},rdpct=${k},seekpct=${j}"
                ms="${i}-${k}%read-${j}seek"
                ALL_TEST_LIST[${#ALL_TEST_LIST[*]}]=${wd}
                ALL_TEST_LIST_TITLE[${#ALL_TEST_LIST_TITLE[*]}]=${ms}

            done
        done
    done

    printf "%s\n" "testBlist:${ALL_TEST_LIST[*]}" >> ${LOG_FILE}
}

getTestListF(){
    for i in ${FILESELECT[*]}
    do
        for j in ${BLOCK[*]}
        do
            for k in ${OPERATION[*]}
            do
                for f in ${FILEIO[*]}
                do
                    #设定参数
                    fwd="operation=$k,xfersize=$j,fileio=$i,fileselect=$f"
                    ms="${j}-${f}-$k-$i.s"
                    ALL_TEST_LIST[${#ALL_TEST_LIST[*]}]=${fwd}
                    ALL_TEST_LIST_TITLE[${#ALL_TEST_LIST_TITLE[*]}]=${ms}
                done
            done
        done
    done

    printf "%s\n" "testFlist:${ALL_TEST_LIST[*]}" >> ${LOG_FILE}
}

getwd(){
    WD_LIST=()
    for ((i=0;i<${#ALL_TEST_LIST[*]};i++))
    do
        WD_LIST[$i]="wd=wd$i,sd=sd*,${ALL_TEST_LIST[$i]}"
    done

    printf "%s\n" "wdlist:${WD_LIST[*]}" >> ${LOG_FILE}
}



getsd(){
    SD_LIST=()

    for ((i=0;i<${#IP_LIST[*]};i++))
    do
        commd="multipath -ll |grep -B2 $V_SI|grep $BRAND|awk '{print \$1}'"
        DN=(`ssh ${IP_LIST[$i]} "$commd"`)
        for ((j=0;j<${#DN[*]};j++))
        do
           count=`echo $i*${#DN[*]}+$j |bc`
           SD_LIST[${#SD_LIST[*]}]="sd=sd$count,hd=hd$i,lun=/dev/mapper/${DN[$j]}"
        done
    done
    printf "%s\n" "sdlist:${SD_LIST[*]}" >> ${LOG_FILE}
}


getrd(){
    RD_LIST=()
    for ((i=0;i<${#ALL_TEST_LIST[*]};i++))
    do
        RD_LIST[$i]="rd=rd$i,wd=wd$i,threads=$THREADS,iorate=max,elapsed=$ELAPSED,interval=$INTERVAL,warmup=$WARMUP,pause=$PAUSE"
    done
    printf "%s\n" "rdlist:${RD_LIST[*]}" >> ${LOG_FILE}
}


# host.vdb
setHost(){
printf "%s\n" "hd=default,user=root,vdbench=$VD_HOME,shell=ssh,jvms=${#IP_LIST[*]}" > ${VD_FILE}/host.vdb
for ((i=0;i<${#IP_LIST[*]};i++))
do
    printf "%s\n" "hd=hd${i},system=${IP_LIST[$i]}" >> ${VD_FILE}/host.vdb
done
}

# volume.vdb
setVol(){
printf "%s\n" "sd=default,openflags=o_direct" > ${VD_FILE}/volume.vdb
for ((i=0;i<${#SD_LIST[*]};i++))
do
    printf "%s\n" "${SD_LIST[$i]}" >> ${VD_FILE}/volume.vdb
done
}

# run.vdb
setTerm(){
    printf "%s\n%s\n%s\n" "messagescan=no" "include=host.vdb" "include=volume.vdb" > ${VD_FILE}/run.vdb
    for ((i=0;i<${#ALL_TEST_LIST[*]};i++))
    do
        #printf "%s\n%s\n" ${WD_LIST[$i]} ${RD_LIST[$i]} >> ${VD_FILE}/run.vdb
        printf "%s\n" ${WD_LIST[$i]}  >> ${VD_FILE}/run.vdb
    done
    for ((i=0;i<${#ALL_TEST_LIST[*]};i++))
    do
        printf "%s\n"  ${RD_LIST[$i]} >> ${VD_FILE}/run.vdb
    done
}

runVdb-nohup(){
    nohup $VD_HOME/vdbench -f ${VD_FILE}/run.vdb -o $VD_OUT >> $VD_LOG/run.vdb.$FILE_DATE 2>&1 &
    if [ $? -eq 0 ];then
        printf "\033[32m%s\033[0m\n%s\n" "successful run vdb" "PID:$!" >> ${LOG_FILE}
    else
        printf "\033[31m%s\033[0m\n%s\n" "error!" "PID:$!" >> ${LOG_FILE}
    fi
}

runVdb(){

    $VD_HOME/vdbench -f ${VD_FILE}/run.vdb -o $VD_OUT
}

getDataMakePic(){
    for ((i=0;i<${#ALL_TEST_LIST_TITLE[*]};i++))
    do
        data_name="$VD_OUT/${ALL_TEST_LIST_TITLE[$i]}"
        f_n=`echo $ONE_RD_COUNT*$i+1|bc`
        l_n=`echo $ONE_RD_COUNT*$i+$ONE_RD_COUNT|bc`
        awk '$3~/^[0-9]*\./{print $3}' $VD_OUT/summary.html | awk "NR>=$f_n && NR<=$l_n" > $data_name.iops
        awk '$3~/^[0-9]*\./{print $4}' $VD_OUT/summary.html | awk "NR>=$f_n && NR<=$l_n" > $data_name.bs
        cp IOLine.py-bak IOLine.py
        sed -i "s!LINE_TITLE!${ALL_TEST_LIST_TITLE[$i]}!g" IOLine.py
        sed -i "s!SAVE_PATH!$VD_OUT!g" IOLine.py
        python3  IOLine.py
    done
    awk '$3~/^[0-9]*\./{printf "%s\n","block:"$5"--iops:"$3"--bs:"$4"--resp:"$7}' $VD_OUT/totals.html  > $VD_OUT/total.sin
}



vd-createFile(){
    checkVal
    getsd
    getTestListB
    getwd
    getrd
    getsd
    setHost
    setVol
    setTerm
}

vd-normal(){
    checkVal
    getTestListB
    getwd
    getrd
    getsd
    setHost
    setVol
    setTerm
    runVdb
    getDataMakePic
}


## main ##

if [ x$1 == x ];then
    read -p "you wile use default mode! please enter yes to continue! " USE_DEFAULT
    if [ $USE_DEFAULT == "yes" -o $USE_DEFAULT == "y" ]
    then
        echo "run in default"
    else
        echo "don't run!"
        exit 0
    fi
elif [ $1 == "default" ];then
    echo "run in default"
else
    echo "use free mode!"
fi

LINE=`getopt -o a --long help,brand:,mode:,type:,ip:,size:,rdpct:,block:,fileio:,seekpct:,runtime:,interval:,warmp:,pause:,file:,out:,log:,date: -n 'Invalid parameter' -- "$@"`

if [ $? != 0 ] ; then usage; exit 1 ; fi

eval set -- "$LINE"

while true;do
    case "$1" in
    --h)
    usage; shift 2;;
    --help)
    usage; shift 2;;
    --brand)
    BRAND=$2; shift 2;;
    --mode)
    VD_TYPE=$2; shift 2;;
    --type)
    VD_TYPE=$2; shift 2;;
    --ip)
    IP_LIST=($2); shift 2;;
    --size)
    V_SI=$2; shift 2;;
    --rdpct)
    RDPCT=($2); shift 2;;
    --block)
    BLOCK=($2); shift 2;;
    --fileio)
    FILEIO=($2); shift 2;;
    --seekpct)
    SEEK=($2); shift 2;;
    --runtime)
    ELAPSED=$2; shift 2;;
    --interval)
    INTERVAL=$2; shift 2;;
    --warmup)
    WARMUP=$2; shift 2;;
    --pause)
    PAUSE=$2; shift 2;;
    --file)
    VD_FILE=$2; shift 2;;
    --out)
    VD_OUT=$2; shift 2;;
    --log)
    VD_LOG=$2; shift 2;;
    --date)
    FILE_DATE=$2; shift 2;;
    --)
    shift;break;;
    *)
    break;;
    esac
done


case $mode in
1)
    ;;

2)
    vd-createFile
    runVdb-nohup
    ;;
*)
    echo "aaa" ;;
esac


cat ${LOG_FILE}