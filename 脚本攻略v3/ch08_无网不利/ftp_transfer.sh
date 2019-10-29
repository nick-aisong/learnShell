#!/bin/bash
# FTP传输自动化
HOST='example.com'
USER='foo'
PASSWD='password'
lftp -u ${USER}:${PASSWD} $HOST <<EOF

binary
cd /home/foo
put testfile.jpg

quit
EOF
