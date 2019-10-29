#!/bin/bash
# 文件名: ping.sh
# 根据你所在网络的实际情况修改网络地址192.168.0
for ip in 192.168.0.{1..255};
do
  ping $ip -c 2 &> /dev/null;

  if [ $? -eq 0 ];
  then
    echo $ip is alive
  fi
done 
