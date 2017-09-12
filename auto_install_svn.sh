#!/bin/bash

SVN_DR=/data/svn
SVN_REPO=svnrepos
#安装svn以及创建svn数据库路径
yum install subversion -y
svnserve --version
mkdir -p $SVN_DR
svnadmin create $SVN_DR/$SVN_REPO
ls $SVN_DR/$SVN_REPO
#更改配置文件俺
sed -i 's#OPTIONS=\"-r /var/svn\"#OPTIONS=\"-r $SVN_DR/$SVN_REPO"#g' /etc/sysconfig/svnserve
