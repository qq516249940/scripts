#!/bin/bash
#
# Filename:    sms.sh
# Revision:    1.0
# Date:        2017/09/16
# Author:      chunk
# Email:
# Description: zabbix短信告警脚本
# 
# 脚本的日志文件
LOGFILE="/tmp/send.log"
:>"$LOGFILE"
exec 1>"$LOGFILE"
exec 2>&1
MOBILE_NUMBER=$1        # 手机号码      
MESSAGE_UTF8=$3         # 短信内容 
XXD="/usr/bin/xxd"      # 需要安装vim软件
CURL="/usr/bin/curl"    # 需要安装curl软件来请求网页
TIMEOUT=5
# 短信内容要经过URL编码处理.
MESSAGE_ENCODE=$(echo "$MESSAGE_UTF8" | ${XXD} -ps | sed 's/\(..\)/%\1/g' | tr -d '\n')
# Uid和Key的值需要自行修改
# Uid 网站用户名
# Key 接口秘钥
Uid="此处替换"
Key="此处替换"
Cgid="此处替换"
Csid="此处替换"
URL="http://smsapi.c123.cn/OpenPlatform/OpenApi?action=sendOnce&ac=${Uid}&authkey=${Key}&cgid=${Cgid}&csid=${Csid}&c=${MESSAGE_ENCODE}&m=${MOBILE_NUMBER}"
#echo "$URL"
#Send it
set -x
${CURL} -s --connect-timeout ${TIMEOUT} "${URL}"
