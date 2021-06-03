#!/usr/bin/env bash
rescan-scsi-bus.sh -r
cd /etc/multipath
rm -rf bindings
rm -rf wwids
/etc/init.d/multipath-tools restart
echo "- - -"|tee /sys/class/scsi_host/*/scan -a
cd -
sleep 30
lsblk
