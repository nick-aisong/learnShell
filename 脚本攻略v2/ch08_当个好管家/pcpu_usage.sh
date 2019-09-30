#!/bin/bash
# 文件名: pcpu_usage.sh
# 用途:计算1个小时内进程的CPU占用情况
SECS=3600
UNIT_TIME=60
# 将SECS更改成需要进行监视的总秒数
# UNIT_TIME是取样的时间间隔，单位是秒
STEPS=$(( $SECS / $UNIT_TIME ))
echo Watching CPU usage... ;
for((i=0;i<STEPS;i++))
do
 ps -eocomm,pcpu | tail -n +2 >> /tmp/cpu_usage.$$
 sleep $UNIT_TIME
done
echo
echo CPU eaters :
cat /tmp/cpu_usage.$$ | \
awk '
{ process[$1]+=$2; }
END{
 for(i in process)
 {
 printf("%-20s %s\n",i, process[i]) ;
 }
 }' | sort -nrk 2 | head
rm /tmp/cpu_usage.$$ 

### SECS=36, UNIT_TIME=6

# sshd                 15.2
# bash                 11
# top                  9.6
# java                 4
# rcu_sched            2.4
# avahi-daemon         2.4
# audispd              1.6
# vmtoolsd             0.8
# sedispatch           0.8
# auditd               0.8
