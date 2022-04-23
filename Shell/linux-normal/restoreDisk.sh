#!/usr/bin/env bash
restoreDisk(){
dd   of=/dev/${devname}  if=/root/disk/${devname}   bs=1 count=2000
}

# restoreDisk
echo "sd"{c..z}
mkdir /root/disk
for i in {c..z}
do 
 devname="sd"${i}
 echo "restoreDisk:"${devname}" "
 restoreDisk
 # ls /root
done
echo "successful"