#!/bin/bash

PROJECT="html"
set -e
set -u
DATE=`date "+%Y%m%d"`
TIME=`date "+%H%M"`
WEBAPPS_PATH="/data/backup/web"
backup_web() {
  [ -d $WEBAPPS_PATH/$DATE/$TIME ]||mkdir -p $WEBAPPS_PATH/$DATE/$TIME
  tar -czvf  $WEBAPPS_PATH/$DATE/$TIME/$PROJECT.tar.gz /usr/local/nginx/$PROJECT/*
  echo `ls -hl $WEBAPPS_PATH/$DATE/$TIME`
}
backup_web
