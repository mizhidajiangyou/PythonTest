#!/bin/bash
# 该脚本用于生成单/多主机利用vdbench测试性能
# 脚本模式
MODEL=2
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
VD_FILE="`pwd`"
# VDBENCH目录
VD_HOME="/root/vdbench/"
# 报告目录
VD_OUT="$VD_FILE/vd-output"
# 日志存放目录
VD_LOG="$VD_FILE/log/"
# 日志重定向文件
LOG_FILE="$VD_FILE/log/vd$FILE_DATE.log"
# 测试项
ALL_TEST_LIST=()
# 测试名
ALL_TEST_LIST_TITLE=()
# 使用方法
usage(){
    echo -e "\033[1musage: vdbench.sh [ --help]

    <--model| --type| --ip>
    [--size| --rdpct| --block| --fileio| --seekpct| --runtime| --file| --out] \n
    model     <1|2|3>             1-all 2-vdbench and result 3-only vdbench
    type      <fc|iscsi|nfs>      whether which volume type you test
    ip        <\"ipaddress\">       all ip list which you want to test
    file      <\"vdb file pwd\">    *.vbd will put in
    out       <\"output pwd\">      vdbench out put will put in

    e.g.
    --type fc --ip \"192.168.8.81 192.168.8.82\" --file \"/root/vdbench/aa\" --out \"/root/vdbench/outa\"

    ...\033[0m"

    exit 1

}

# 检查变量正确性
checkVal(){


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
        echo "vdbench is in /root" >> ${LOG_FILE}
    else
        echo "no vdbench！" >> ${LOG_FILE}
        exit 1
    fi

    # 检测IP是否可用

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
        commd="multipath -ll |grep -B2 $V_SI|grep DubheFlash|awk '{print \$1}'"
        DN=(`ssh ${IP_LIST[$i]} "$commd"`)
        for ((j=0;j<${#DN[*]};j++))
        do
           count=`echo $i*${#DN[*]}+$j |bc`
           SD_LIST[${#SD_LIST[*]}]="sd=sd$count,hd=hd$i,lun=/dev/mapper/${DN[$j]}"
        done
    done
    printf "%s\n" "sdlist:${SD_LIST[*]}">> ${LOG_FILE}
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
    printf "%s\n%s\n" "include=host.vdb" "include=volume.vdb" > ${VD_FILE}/run.vdb
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

runVdb(){
    nohup $VD_HOME/vdbench -f ${VD_FILE}/run.vdb -o $VD_OUT >> $VD_LOG/run.vdb.$FILE_DATE 2>&1 &
    if [ $? -eq 0 ];then
        printf "\033[32m%s\033[0m\n%s\n" "successful run vdb" "PID:$!" >> ${LOG_FILE}
    else
        printf "\033[31m%s\033[0m\n%s\n" "error!" "PID:$!" >> ${LOG_FILE}
    fi
}


vd-main(){
    getsd
    checkVal
    getTestListB
    getwd
    getrd
    getsd
    setHost
    setVol
    setTerm
    runVdb
}



LINE=`getopt -o a --long help,type:,ip:,runtime:,file:,out: -n 'Invalid parameter' -- "$@"`



if [ $? != 0 ] ; then usage; exit 1 ; fi

eval set -- "$LINE"

while true;do
    case "$1" in
    --help)
    usage; shift 2;;
    --type)
    VD_TYPE=$2; shift 2;;
    --ip)
    IP_LIST=($2); shift 2;;
    --runtime)
    ELAPSED=$2; shift 2;;
    --file)
    VD_FILE=$2; shift 2;;
    --out)
    VD_OUT=$2; shift 2;;
    --)
    shift;break;;
    *)
    break;;
    esac
done



case $MODEL in

2)
    vd-main ;;
*)
    echo "aaa" ;;
esac