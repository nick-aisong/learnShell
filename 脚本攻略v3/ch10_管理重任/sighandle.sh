#/bin/bash
#文件名：sighandle.sh
#用途: 信号处理程序
function handler()
{
 echo Hey, received signal : SIGINT
}
#$$是一个特殊变量，它可以返回当前进程/脚本的进程ID
echo My process ID is $$
#handler是信号SIGINT的信号处理程序的名称
trap 'handler' SIGINT
while true;
do
 sleep 1
done
