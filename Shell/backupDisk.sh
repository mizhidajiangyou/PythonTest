#!/usr/bin/env bash
backupDisk(){
dd   if=/dev/${devname}  of=/root/disk/${devname}   bs=1 count=2000
}

# backupDisk
echo "sd"{c..z}
mkdir /root/disk
for i in {c..z}
do 
 devname="sd"${i}
 echo "backupDisk:"${devname}" "
 backupDisk
 # ls /root
done
echo "successful"