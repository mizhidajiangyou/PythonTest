#!/bin/bash
# 该脚本用于zfs，创建raid0/5/6/10后创建块设备读写测试性能（利用工具vdbench）
ALL_DISK_LIST=(/dev/sdt /dev/sdu /dev/sdv /dev/sdw /dev/sdx /dev/sdy)
# 卷容量
VOLUME_SIZE=`echo 1024*1024*1024*500|bc`
# 块大小
BLOCK_LIST=(4k 8k 32k 128k)
# vdbench目录
VD_PATH="/root/vdbench/"
RE_PATH="${VD_PATH}report/"
RUN_PATH="${VD_PATH}run/"
mkdir -p ${RE_PATH}
mkdir -p ${RUN_PATH}
# 报告名称
prefix="zfs_0.8.6_"
# 池名
POOL_NAME="pool1"
# zfs命令：
    # zpool create -f -o ashift=0 pool1 raidz1 /dev/sdt /dev/sdr /dev/sdx
    # zfs create -b 32768 -o logbias=latency  -o redundant_metadata=most -o sync=always -V 1073741824 pool1/v1


RAID0_CREATE(){
    # 创建raid0,参数1为盘符
    zpool create -f -o ashift=0 ${POOL_NAME} $1
    # 创建zvol,块大小为参数2，容量为500
    zfs create -b $2 -o logbias=latency  -o redundant_metadata=most -o sync=always -V 536870912000 ${POOL_NAME}/v1
}

RAID5_CREATE(){
    # 创建raid5
    zpool create -f -o ashift=0 ${POOL_NAME} raidz1 $1
    # 创建zvol
    zfs create -b $2 -o logbias=latency  -o redundant_metadata=most -o sync=always -V 536870912000 ${POOL_NAME}/v1
}

RAID6_CREATE(){
    # 创建raid6
    zpool create -f -o ashift=0 ${POOL_NAME} raidz2 $1
    # 创建zvol
    zfs create -b $2 -o logbias=latency  -o redundant_metadata=most -o sync=always -V 536870912000 ${POOL_NAME}/v1
}

RAID10_CREATE(){
    # $1 $2中的磁盘互为镜像，$3为块大小
    DISK_LIST=($1)
    DISK_LIST_MIRROR=($2)
    COMMOND_DISK=""
    for ((i=0;i<${#DISK_LIST[*]};i++))
    do
        COMMOND_DISK=${COMMOND_DISK}"mirror ${DISK_LIST[$i]} ${DISK_LIST_MIRROR[$i]} "
    done
    # 创建raid10
    zpool create -f -o ashift=0 ${POOL_NAME} ${COMMOND_DISK}
    # 创建zvol
    zfs create -b $3 -o logbias=latency  -o redundant_metadata=most -o sync=always -V 536870912000 ${POOL_NAME}/v1
}

##### 待优化
VDBENCH_ZD(){
    # 使用vdbench测试zd设备
    ${VD_PATH}vdbench -f ${RUN_PATH}/zd-1 -o $1
}
TEST_RAID0_1_DISK(){
    for ((i=0;i<${#BLOCK_LIST[*]};i++))
    do
        # 选用第一块磁盘作为数据盘
        RAID0_CREATE "${ALL_DISK_LIST[0]}" "${BLOCK_LIST[$i]}"
        # 使用vdbench测试
        FILE_NAME="${prefix}1_disk_raid1_${BLOCK_LIST[$i]}_1zvol_zd"
        VDBENCH_ZD "${FILE_NAME}"
        cd ${RE_PATH}${FILE_NAME}
        ../report.sh-2 >> ../jl
        zpool destroy -f ${POOL_NAME}
    done
}

TEST_RAID0_1_DISK_LZ4(){
    for ((i=0;i<${#BLOCK_LIST[*]};i++))
    do
        # 选用第一块磁盘作为数据盘
        RAID0_CREATE "${ALL_DISK_LIST[0]}" "${BLOCK_LIST[$i]}"
        # 修改zfs属性
        a=`zfs list|wc -l`;zfs list|sed -n "3,${a}p"|awk '{print $1}'|xargs zfs set compression=lz4
        # 使用vdbench测试
        FILE_NAME="${prefix}1_disk_raid1_${BLOCK_LIST[$i]}_1zvol_zd_lz4"
        VDBENCH_ZD "${FILE_NAME}"
        cd ${RE_PATH}${FILE_NAME}
        ../report.sh-2 >> ../jl
        zpool destroy -f ${POOL_NAME}
    done
}

TEST_RAID0_1_DISK_LZ4_NO_CHECK(){
    for ((i=0;i<${#BLOCK_LIST[*]};i++))
    do
        # 选用第一块磁盘作为数据盘
        RAID0_CREATE "${ALL_DISK_LIST[0]}" "${BLOCK_LIST[$i]}"
        # 修改zfs属性
        a=`zfs list|wc -l`;zfs list|sed -n "3,${a}p"|awk '{print $1}'|xargs zfs set compression=lz4
        b=`zfs list|wc -l`;zfs list|sed -n "3,${b}p"|awk '{print $1}'|xargs zfs set checksum=off
        # 使用vdbench测试
        FILE_NAME="${prefix}1_disk_raid1_${BLOCK_LIST[$i]}_1zvol_lz4_checksum_off"
        VDBENCH_ZD "${FILE_NAME}"
        cd ${RE_PATH}${FILE_NAME}
        ../report.sh-2 >> ../jl
        zpool destroy -f ${POOL_NAME}
    done
}

TEST_RAID0_1_DISK_LZ4_NO_CHECK
TEST_RAID0_1_DISK_LZ4
TEST_RAID0_1_DISK