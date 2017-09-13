#!/bin/sh
#author=yancong
#EMAIL:516249940@qq.com
#version 1.0
#备份/data目录

srcdir=/data/
dstdir=gitlab_bakcup
excludedir=/script/inotify/exclude.list
rsyncuser=rsync
rsyncpassdir=/etc/passwd.txt
dstip="192.168.3.200"
for ip in $dstip
  do
    rsync -avH --port=873 --progress --delete  --exclude-from=$excludedir  $srcdir $rsyncuser@$ip::$dstdir --password-file=$rsyncpassdir
  done

echo "`date`   Backup /data success" >> /tmp/gitlab_bakcup.log
