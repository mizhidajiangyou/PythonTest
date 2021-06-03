#!/usr/bin/env bash
VOLUME_SIZE=107374182400
BLOCK_SIZE=32768
DISK_LIST=(sdc sdd sde sdf sdg sdh sdi sdj sdk sdl sdm sdn sdo sdp sdq sdsr sds sdt sdu sdv sdw sdx sdy sdz)
VOLUME_NUM=(0 1 2 3)

for i in ${DISK_LIST[*]}
    do
        disk=${i}
        pool="p"${i}
        echo "from disk:"${disk}" create pool"
        zpool create ${pool} -o ashift=12  /dev/${disk}
        for j in ${VOLUME_NUM[*]}
            do
                volume="v"${j}
                echo "from pool:"${pool}" create volume:"${volume}
                zfs create -b ${BLOCK_SIZE} -o logbias=latency -o redundant_metadata=most -o sync=always -o flexvisor:volsig=v0 -V ${VOLUME_SIZE} ${pool}/${volume}
            done
    done


