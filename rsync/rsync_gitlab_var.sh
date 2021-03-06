#!/bin/sh
#author=yancong
#EMAIL:516249940@qq.com
#version 1.0
#备份/opt/gitlab/目录

srcdir=/opt/gitlab/
dstdir=gitlab_var
excludedir=/script/inotify/exclude.list
rsyncuser=rsync
rsyncpassdir=/etc/passwd.txt
dstip="192.168.3.200"
for ip in $dstip
  do
    rsync -avH --port=873 --progress --delete  --exclude-from=$excludedir  $srcdir $rsyncuser@$ip::$dstdir --password-file=$rsyncpassdir
  done

echo "`date`   Backup /opt/gitlab success" >> /tmp/gitlab_var.log
