#!/bin/bash
# 文件名: uptime.sh
# 用途:系统运行时间监视器
IP_LIST="192.168.0.1 192.168.0.5 192.168.0.9"
USER="test"
for IP in $IP_LIST;
do
  utime=$(ssh ${USER}@${IP} uptime | awk '{ print $3 }' )
  echo $IP uptime: $utime
done 
