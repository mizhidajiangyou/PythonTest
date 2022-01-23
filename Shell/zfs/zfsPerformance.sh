#!/bin/bash
# 返回码
    # 9 磁盘数量错误
# 该脚本用于zfs，创建raid0/5/6/10后创建块设备读写测试性能（利用工具vdbench）
ALL_DISK_LIST=(/dev/sdt /dev/sdu /dev/sdv /dev/sdw /dev/sdx /dev/sdy /dev/sds /dev/sdr /dev/sdo /dev/sdz /dev/sdp /dev/sdq)
# 用于写缓存的磁盘
LOG_DISK_LIST="/dev/sdf /dev/sdg"
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
    for ((j=0;j<${#DISK_LIST[*]};j++))
    do
        COMMOND_DISK=${COMMOND_DISK}"mirror ${DISK_LIST[$j]} ${DISK_LIST_MIRROR[$j]} "
    done
    # 创建raid10
    zpool create -f -o ashift=0 ${POOL_NAME} ${COMMOND_DISK}
    # 创建zvol
    zfs create -b $3 -o logbias=latency  -o redundant_metadata=most -o sync=always -V 536870912000 ${POOL_NAME}/v1
}

ZPOOL_SET(){
    # 选择zpool属性
    case $1 in
    log)
        zpool add ${POOL_NAME} log ${LOG_DISK_LIST}
        zpool history
        ;;
    *)
        echo "not set anything!"
        ;;
    esac

}

ZFS_SET(){
    # 选择zfs属性
    case $1 in
    lz4)
        a=`zfs list|wc -l`;zfs list|sed -n "3,${a}p"|awk '{print $1}'|xargs zfs set compression=lz4
        ;;
    check)
        b=`zfs list|wc -l`;zfs list|sed -n "3,${b}p"|awk '{print $1}'|xargs zfs set checksum=off
        ;;
    lac)
        a=`zfs list|wc -l`;zfs list|sed -n "3,${a}p"|awk '{print $1}'|xargs zfs set compression=lz4
        b=`zfs list|wc -l`;zfs list|sed -n "3,${b}p"|awk '{print $1}'|xargs zfs set checksum=off
        ;;
    *)
        echo "not set anything!"
        ;;
    esac
}
##### 待优化
VDBENCH_ZD(){
    # 使用vdbench测试zd设备
    ${VD_PATH}vdbench -f ${RUN_PATH}/zd-1 -o ${RE_PATH}$1
}

# 使用给定个数测磁盘进行测试，磁盘个数为$1;zfs模式为参数$2;zpool模式为$3可不填
TEST_RAID0_X_DISK(){
# 判断请求的磁盘个数是否满足
if [ $1 -le ${#ALL_DISK_LIST[*]} ];then
    echo use $1 disk to test!
else
    echo error!
    exit 0
fi
for ((i=0;i<${#BLOCK_LIST[*]};i++))
    do
        # 选用第X块磁盘作为数据盘
        RAID0_CREATE "${ALL_DISK_LIST[*]:0:$1}" "${BLOCK_LIST[$i]}"
        # 选择zpool
        ZPOOL_SET $3
        # 选择zfs属性
        ZFS_SET $2
        # 使用vdbench测试
        FILE_NAME="${prefix}$1_disk_raid0$3_${BLOCK_LIST[$i]}_1zvol_$2"
        VDBENCH_ZD "${FILE_NAME}"
        cd ${RE_PATH}${FILE_NAME}
        ../report.sh-2 >> ../jl
        zpool destroy -f ${POOL_NAME}
    done
}

TEST_RAID5_X_DISK(){
    # 判断请求的磁盘个数是否满足
    if [ $1 -le ${#ALL_DISK_LIST[*]} ];then
        echo use $1 disk to test!
        if [ $1 -lt 3 ];then
            echo raid5 should use more than 3 disk!
            exit 9
        fi
    else
        echo error!
        exit 9
    fi

    for ((i=0;i<${#BLOCK_LIST[*]};i++))
    do
        # 选用X块磁盘作为数据盘
        RAID5_CREATE "${ALL_DISK_LIST[*]:0:$1}" "${BLOCK_LIST[$i]}"
        # 选择zpool
        ZPOOL_SET $3
        # 选择zfs属性
        ZFS_SET $2
        # 使用vdbench测试
        FILE_NAME="${prefix}$1_disk_raid5$3_${BLOCK_LIST[$i]}_1zvol_$2"
        VDBENCH_ZD "${FILE_NAME}"
        cd ${RE_PATH}${FILE_NAME}
        ../report.sh-2 >> ../jl
        zpool destroy -f ${POOL_NAME}
    done
}


TEST_RAID6_X_DISK(){
    # 判断请求的磁盘个数是否满足
    if [ $1 -le ${#ALL_DISK_LIST[*]} ];then
        echo use $1 disk to test!
        if [ $1 -lt 4 ];then
            echo raid6 should use more than 4 disk!
            exit 9
        fi
    else
        echo error!
        exit 9
    fi

    for ((i=0;i<${#BLOCK_LIST[*]};i++))
    do
        # 选用X块磁盘作为数据盘
        RAID6_CREATE "${ALL_DISK_LIST[*]:0:$1}" "${BLOCK_LIST[$i]}"
        # 选择zpool
        ZPOOL_SET $3
        # 选择zfs属性
        ZFS_SET $2
        # 使用vdbench测试
        FILE_NAME="${prefix}$1_disk_raid6$3_${BLOCK_LIST[$i]}_1zvol_$2"
        VDBENCH_ZD "${FILE_NAME}"
        cd ${RE_PATH}${FILE_NAME}
        ../report.sh-2 >> ../jl
        zpool destroy -f ${POOL_NAME}
    done
}

TEST_RAID10_X_DISK(){
    # 判断请求的磁盘个数是否满足
    if [ $1 -le ${#ALL_DISK_LIST[*]} ];then
        echo use $1 disk to test!
        if [ $1 -lt 2 ];then
            echo raid10 should use more than 2 disk!
            exit 9
        fi
    else
        echo error!
        exit 9
    fi

    DISK_NUM=`echo $1/2|bc`
    for ((i=0;i<${#BLOCK_LIST[*]};i++))
    do
        # 选用X块磁盘作为数据盘
        RAID10_CREATE "${ALL_DISK_LIST[*]:0:$DISK_NUM}" "${ALL_DISK_LIST[*]: -$DISK_NUM}" "${BLOCK_LIST[$i]}"
        # 选择zpool
        ZPOOL_SET $3
        # 选择zfs属性
        ZFS_SET $2
        # 使用vdbench测试
        FILE_NAME="${prefix}$1_disk_raid10$3_${BLOCK_LIST[$i]}_1zvol_$2"
        VDBENCH_ZD "${FILE_NAME}"
        cd ${RE_PATH}${FILE_NAME}
        ../report.sh-2 >> ../jl
        zpool destroy -f ${POOL_NAME}
    done
}


TEST_RAID10_X_DISK 6 "zd" "log"
TEST_RAID10_X_DISK 6 "lz4" "log"
TEST_RAID10_X_DISK 6 "check" "log"
TEST_RAID10_X_DISK 6 "lac" "log"
TEST_RAID5_X_DISK 6 "zd" "log"
TEST_RAID5_X_DISK 6 "lz4" "log"
TEST_RAID5_X_DISK 6 "check" "log"
TEST_RAID5_X_DISK 6 "lac" "log"
TEST_RAID6_X_DISK 6 "zd" "log"
TEST_RAID6_X_DISK 6 "lz4" "log"
TEST_RAID6_X_DISK 6 "check" "log"
TEST_RAID6_X_DISK 6 "lac" "log"
TEST_RAID10_X_DISK 12 "zd" "log"
TEST_RAID10_X_DISK 12 "lz4" "log"
TEST_RAID10_X_DISK 12 "check" "log"
TEST_RAID10_X_DISK 12 "lac" "log"
TEST_RAID5_X_DISK 12 "zd" "log"
TEST_RAID5_X_DISK 12 "lz4" "log"
TEST_RAID5_X_DISK 12 "check" "log"
TEST_RAID5_X_DISK 12 "lac" "log"
TEST_RAID6_X_DISK 12 "zd" "log"
TEST_RAID6_X_DISK 12 "lz4" "log"
TEST_RAID6_X_DISK 12 "check" "log"
TEST_RAID6_X_DISK 12 "lac" "log"