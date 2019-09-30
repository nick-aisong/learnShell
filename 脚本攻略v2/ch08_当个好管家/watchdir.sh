#/bin/bash
# 文件名: watchdir.sh
# 用途:监视目录访问
path=$1
# 将目录或文件路径作为脚本参数
inotifywait -m -r -e create,move,delete $path -q

### create file a and delete file a in another terminal
# [root@NickCOS72V1 ch08_当个好管家]# ./watchdir.sh ../
# ../ch08_当个好管家/ CREATE a
# ../ch08_当个好管家/ DELETE a

### vim reset_password.sh
# [root@NickCOS72V1 ch08_当个好管家]# ./watchdir.sh ~
# /root/ CREATE .reset_password.sh.swp
# /root/ CREATE .reset_password.sh.swx
# /root/ DELETE .reset_password.sh.swx
# /root/ DELETE .reset_password.sh.swp
# /root/ CREATE .reset_password.sh.swp
# /root/ CREATE .viminfo.tmp
# /root/ DELETE .viminfo
# /root/ MOVED_FROM .viminfo.tmp
# /root/ MOVED_TO .viminfo
# /root/ DELETE .reset_password.sh.swp