#!/bin/bash
#author=yancong
#EMAIL:516249940@qq.com
#version 1.0
#del 3days ago "*.stderrout.log.*"
LOG_DR=/data/jetty-app/web/
DAYS=3
DB=yunxin
DATE=`date +%y%m%d`
archive=${DB}_${DATE}


   
find $LOG_DR -name "*.stderrout.log.*"  -type f -mtime +3 -exec rm -rf {} \;
echo "`date`  clean $i log is ok" >> /tmp/clean2_logs.log
