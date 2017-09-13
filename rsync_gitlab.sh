#!/bin/sh
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
