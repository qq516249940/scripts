#!/bin/bash
#author=yancong
#EMAIL:516249940@qq.com
#version 1.0
#del 3days ago *.log
LOG_DR=/data/logs/m2c/
DAYS=3
DB=yunxin
DATE=`date +%y%m%d`
archive=${DB}_${DATE}

for i in `ls -F /data/logs/m2c/ |grep "/$"`
  do       
      find $LOG_DR$i*.log -type f -mtime +3 -exec rm -rf {} \;
      echo "`date`  clean $i log is ok" >> /tmp/clean_logs.log
  done 
