#!/bin/sh
#author=yancong
#EMAIL:516249940@qq.com
#version 1.0

srcdir=/etc/gitlab/
dstdir=etc_gitlab
excludedir=/script/inotify/exclude.list
rsyncuser=rsync
rsyncpassdir=/etc/passwd.txt
dstip="192.168.3.200"
for ip in $dstip
  do
    rsync -avH --port=873 --progress --delete  --exclude-from=$excludedir  $srcdir $rsyncuser@$ip::$dstdir --password-file=$rsyncpassdir
  done

echo "`date`   Backup $srcdir success" >> /tmp/rsync_etc_gitlab.log
