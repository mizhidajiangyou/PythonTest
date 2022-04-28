#!/usr/bin/env bash
# 该脚本用于改变环境配置变量


if [ `find / -type d -name "myTest" |wc -l` -ne 1 ]
then
    echo "error!more than one testFile! please delete or manual add python path!"
    exit 1
fi

if [ "${ZHOME}" == "" ]
then
    ZHOME=`find / -type d -name "myTest"`
    echo "export ZHOME=$ZHOME/" >> /etc/profile
fi


if [ "${PYTHONPATH}" != "$ZHOME" ]
then
    echo "export PYTHONPATH=$ZHOME/" >> /etc/profile
    source /etc/profile
fi





