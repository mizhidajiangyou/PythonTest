#!/usr/bin/env bash
echo "池损耗计算公式=（磁盘容量-池容量）/磁盘容量"
echo "卷损耗公式=（卷实际占用量-卷请求容量)/卷请求容量"
POOL_NAME="zpool"
DISK_SIZE="745.2"
SAVE_PATH="./output/zpooltest"
# 测试项
POOL_TEST=(RAID0 RAID10 RAID5 RAID6 RAID50 RAID60)
VOLUME_TEST=("512" "1k" "2k" "4k" "8k" "16k" "32k" "64k" "128k")
# 测试数据存放文件
TEST_DATA=${SAVE_PATH}"TEST_DATA"
# 存放绘图数据的文件夹
USE_DATA=${SAVE_PATH}"p_data/"
mkdir -p ${USE_DATA}
SAVE_FILE_NAME=""
SAVE_POOL_PATH=${USE_DATA}${SAVE_FILE_NAME}
DISK_LIST=()
VOLUME_NAME=zvol
# 块大小设置
BLOCK_LIST=(512 1024 2048 4096 8192 16384 32768 65536 131072)
BLOCK_DES=("512" "1k" "2k" "4k" "8k" "16k" "32k" "64k" "128k")
# 卷容量设置
#VOL_SIZE_LIST=(274877906944 549755813888 1099511627776 2199023255552)
#VOL_SIZE_LIST=(1073741824 10737418240 53687091200 107374182400 214748364800)
VOL_SIZE_LIST=()
VOL_SIZE_DES=()
for i in {1..100}
do
    SIZE=`echo 1073741824*$i | bc`
    VOL_SIZE_LIST[${#VOL_SIZE_LIST[*]}]=$SIZE
    VOL_SIZE_DES[${#VOL_SIZE_DES[*]}]=$i
done
#VOL_SIZE_DES=("0.25T" "0.5T" "1T" "2T")
# 零时中间数值
LS_NUM=""
# 将损耗比变为易读的方式
CHANGE_NUM(){
    if [ "${1:0:1}" == "." ];then
        LS_NUM="0"${1}
    elif [ "${1:0:1}" == "-" ];then
        LS_NUM=0
    else
        LS_NUM=$1
    fi
}

zpoolinfo(){
# 使用磁盘容量
USE_DISK_SIZE=`echo "scale=1; ${DISK_SIZE}*${1}" | bc`
# 尺容量
POOL_SIZE=`zfs get all ${POOL_NAME} | grep -w available|awk '{print $3}'`
echo USE_DISK_SIZE=${USE_DISK_SIZE} >> ${TEST_DATA}
echo POOL_SIZE=${POOL_SIZE} >> ${TEST_DATA}
echo TEST_INFO=${SAVE_FILE_NAME} >> ${TEST_DATA}
echo USE_DISK=${1} >> ${TEST_DATA}
echo ${POOL_SIZE:0-1}
if [ "${POOL_SIZE:0-1}" == "T" ];then
        POOL_SIZE=`echo "scale=1; ${POOL_SIZE:0:0-1}*1024" | bc`
else
        POOL_SIZE=${POOL_SIZE:0:0-1}
fi


POOL_STATUS=`zpool status`
POOL_LOSS=`echo "scale=4; (${USE_DISK_SIZE}-${POOL_SIZE})/${USE_DISK_SIZE}" | bc`

CHANGE_NUM ${POOL_LOSS}
${POOL_LOSS}=${LS_NUM}

echo POOL_LOSS=${POOL_LOSS} >> ${TEST_DATA}
# 保存绘图使用的数据
SAVE_POOL_FILE=${USE_DATA}${SAVE_FILE_NAME}
mkdir -p ${SAVE_POOL_FILE}
SAVE_POOL_PATH=${SAVE_POOL_FILE}"/pool"
echo ${POOL_LOSS} >> ${SAVE_POOL_PATH}
echo ${1} >>  ${SAVE_POOL_PATH}

}



ZVOL_INFO(){
# 卷实际容量。
VOL_SIZE=`zfs get all ${POOL_NAME}/${VOLUME_NAME} | grep -w used | awk '{print $3}'`
# 保存数据至记录文件
echo "VOL SIZE=" ${VOL_SIZE} >> ${TEST_DATA}
echo "SED VOLUME SIZE=" ${3}"G" >> ${TEST_DATA}

# 并将T/G换算成字节
if [ "${VOL_SIZE:0-1}" == "T" ];then
    VOL_SIZE=`echo "scale=1; ${VOL_SIZE:0:0-1}*1024*1024*1024*1024" | bc`
elif [ "${VOL_SIZE:0-1}" == "G" ];then
    VOL_SIZE=`echo "scale=1; ${VOL_SIZE:0:0-1}*1024*1024*1024" | bc`
fi
VOL_ADD=`echo "scale=3; (${VOL_SIZE}-${1})/${1}" | bc`
CHANGE_NUM $VOL_ADD
VOL_ADD=$LS_NUM
echo "VOL_ADD="${VOL_ADD} >> ${TEST_DATA}
# 保存绘图用的卷数据
SAVE_VOLUME_PATH=${SAVE_POOL_FILE}/${2}.${4}disk.volume
echo ${VOL_ADD} >> ${SAVE_VOLUME_PATH}
echo ${3} >> ${SAVE_VOLUME_PATH}

}

RAID0_TEST(){
    DISK_LIST=()
    for i in {c..z}
    do
        DISK_LIST[${#DISK_LIST[*]}]=sd${i}
        zpool create ${POOL_NAME} ${DISK_LIST[*]} -f
        sleep 10
        ZPOOL_INFO ${#DISK_LIST[*]}
        VOL_TEST ${#DISK_LIST[*]}
        zpool destroy -f ${POOL_NAME}
        sleep 10
    done
}
RAID5_TEST(){

    DISK_LIST=(sdc sdd)
    for i in {e..z}
    do
        DISK_LIST[${#DISK_LIST[*]}]=sd${i}
        zpool create ${POOL_NAME} raidz ${DISK_LIST[*]} -f
        DISK_KNOW=`echo ${#DISK_LIST[*]}-1|bc`
        ZPOOL_INFO ${DISK_KNOW}
        VOL_TEST ${DISK_KNOW}
        zpool destroy -f ${POOL_NAME}
    done
}
RAID6_TEST(){
    DISK_LIST=(sdc sdd sdf)
    for i in {f..z}
    do
        DISK_LIST[${#DISK_LIST[*]}]=sd${i}
        zpool create ${POOL_NAME} raidz2 ${DISK_LIST[*]} -f
        DISK_KNOW=`echo ${#DISK_LIST[*]}-2|bc`
        ZPOOL_INFO ${DISK_KNOW}
        VOL_TEST ${DISK_KNOW}
        zpool destroy -f ${POOL_NAME}
    done
}
RAID10_TEST(){

    DISK_LIST=(sd{c..n})
    DISK_LIST_MIRROR=(sd{o..z})
    for ((i=0;i<${#DISK_LIST[*]};i++))
    do
        COMMOND_DISK=""
        for  ((j=0;j<=$i;j++))
        do
            COMMOND_DISK=${COMMOND_DISK}"mirror ${DISK_LIST[$j]} ${DISK_LIST_MIRROR[$j]} "
        done
        KNOW_MIRROR_NUM=$i+1
        zpool create ${POOL_NAME} ${COMMOND_DISK} -f
        DISK_KNOW=`echo ${KNOW_MIRROR_NUM}*2|bc`
        ZPOOL_INFO ${DISK_KNOW}
        VOL_TEST ${DISK_KNOW}
        zpool destroy -f ${POOL_NAME}
    done
}
RAID50_TEST(){

    DISK_LIST=(sd{c..n})
    DISK_LIST_MIRROR=(sd{o..z})

    for ((i=0;i<${#DISK_LIST[*]}-2;i++))
    do

        DISK_COUNT=`echo $i+3|bc`
        COMMOND_DISK="raidz ${DISK_LIST[@]:0:$DISK_COUNT} raidz ${DISK_LIST_MIRROR[@]:0:$DISK_COUNT}"
        zpool create ${POOL_NAME} ${COMMOND_DISK} -f
        DISK_KNOW=`echo $DISK_COUNT*2-2 | bc`
        ZPOOL_INFO ${DISK_KNOW}
        VOL_TEST ${DISK_KNOW}
        zpool destroy -f ${POOL_NAME}
    done
}
RAID60_TEST(){

    DISK_LIST=(sd{c..n})
    DISK_LIST_MIRROR=(sd{o..z})

    for ((i=0;i<${#DISK_LIST[*]}-3;i++))
    do

        DISK_COUNT=`echo $i+4|bc`
        COMMOND_DISK="raidz2 ${DISK_LIST[@]:0:$DISK_COUNT} raidz2 ${DISK_LIST_MIRROR[@]:0:$DISK_COUNT}"
        zpool create ${POOL_NAME} ${COMMOND_DISK} -f
        DISK_KNOW=`echo $DISK_COUNT*2-4 | bc`
        ZPOOL_INFO ${DISK_KNOW}
        VOL_TEST ${DISK_KNOW}
        zpool destroy -f ${POOL_NAME}
    done
}
RAID50_3DISK_TEST(){

    DISK_LIST=(sd{c..z})

    for ((i=0;i<${#DISK_LIST[*]}/3;i++))
    do
        COMMOND_DISK=""
        for  ((j=0;j<=$i;j++))
        do
            COMMOND_DISK=${COMMOND_DISK}"raidz ${DISK_LIST[@]:$j*3:3}"
        done
        KNOW_MIRROR_NUM=`echo $i*2+2 | bc`
        zpool create ${POOL_NAME} ${COMMOND_DISK} -f
        DISK_KNOW=`echo ${KNOW_MIRROR_NUM}*2|bc`
        ZPOOL_INFO ${DISK_KNOW}
        VOL_TEST ${DISK_KNOW}
        zpool destroy -f ${POOL_NAME}
    done
}
RAID60_3DISK_TEST(){

    DISK_LIST=(sd{c..z})

    for ((i=0;i<${#DISK_LIST[*]}/4;i++))
    do
        COMMOND_DISK=""
        for  ((j=0;j<=$i;j++))
        do
            COMMOND_DISK=${COMMOND_DISK}"raidz2 ${DISK_LIST[@]:$j*4:4}"
        done
        KNOW_MIRROR_NUM=`echo $i*2+2 | bc`
        zpool create ${POOL_NAME} ${COMMOND_DISK} -f
        DISK_KNOW=`echo ${KNOW_MIRROR_NUM}*2|bc`
        ZPOOL_INFO ${DISK_KNOW}
        VOL_TEST ${DISK_KNOW}
        zpool destroy -f ${POOL_NAME}
    done
}
VOL_TEST(){
    for ((iv=0;iv<${#BLOCK_LIST[*]};iv++))

    do
        for ((jv=0;jv<${#VOL_SIZE_LIST[*]};jv++))
        do
            zfs create -b ${BLOCK_LIST[$iv]} -o logbias=latency  -o redundant_metadata=most -o sync=always -V ${VOL_SIZE_LIST[$jv]} ${POOL_NAME}/${VOLUME_NAME}
            sleep 3
            ZVOL_INFO ${VOL_SIZE_LIST[$jv]} ${BLOCK_LIST[$iv]} ${VOL_SIZE_DES[$jv]} ${1}
            zfs destroy ${POOL_NAME}/${VOLUME_NAME}  -f
            sleep 3
        done
    done

}

POOL_TEST=(RAID0 RAID10 RAID5 RAID6 RAID50 RAID60)
for ((r=0;r<${#POOL_TEST[*]};r++))
do
    case ${POOL_TEST[$r]} in
    RAID0)
        SAVE_FILE_NAME="pool_raid0"
        RAID0_TEST
        ;;
    RAID10)
        SAVE_FILE_NAME="pool_raid10"
        RAID10_TEST
        ;;
    RAID5)
        SAVE_FILE_NAME="pool_raid5"
        RAID5_TEST
        ;;
    RAID6)
        SAVE_FILE_NAME="pool_raid6"
        RAID6_TEST
        ;;
    RAID50)
        SAVE_FILE_NAME="pool_raid50"
        RAID50_TEST
        ;;
    RAID60)
        SAVE_FILE_NAME="pool_raid60"
        RAID60_TEST
        ;;
    *)
        echo "error!"
        ;;
    esac
done