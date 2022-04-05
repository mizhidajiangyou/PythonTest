#!/usr/bin/env bash
# 本脚本用于centeros配置基础vdbench运行环境
nmcli con mod em1 ipv4.dns "114.114.114.114 8.8.8.8"
nmcli con up em1
yum install -y  java fio device-mapper-multipath vim  iscsi-initiator-utils nfs-utils sysstat chrony expect