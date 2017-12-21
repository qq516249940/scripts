#!/bin/bash
set -e
set -u
DATE=`date "+%Y%m%d"`
TIME=`date "+%H%M"`
WEBAPPS_PATH="/data/backup/webapps"
backup_war() {
  [ -d $WEBAPPS_PATH/$DATE/$TIME ]||mkdir -p $WEBAPPS_PATH/$DATE/$TIME
  cp -f m2c.*.war $WEBAPPS_PATH/$DATE/$TIME
  echo `ls -hl $WEBAPPS_PATH/$DATE/$TIME`
}
backup_war
