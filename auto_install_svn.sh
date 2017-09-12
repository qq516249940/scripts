#!/bin/bash
#author=yancong
#EMAIL:516249940@qq.com
#version 1.0
#auto install svn and start

SVN_DR=/data/svn
SVN_REPO=svnrepos
#安装svn以及创建svn数据库路径
yum install subversion -y
svnserve --version
mkdir -p $SVN_DR
svnadmin create $SVN_DR/$SVN_REPO
ls $SVN_DR/$SVN_REPO
#添加admin用户
sed -i '/# sally = sallyssecret/a\#添加admin用户\nadmin = 123456' /data/svn/svnrepos/conf/passwd
#添加admin用户权限为rw
sed -i '$a\\n#添加新建的用户admin，并授予rw权限\n[/]\nadmin = rw' /data/svn/svnrepos/conf/authz

#更改配置文件俺
sed -i 's#OPTIONS=\"-r /var/svn\"#OPTIONS=\"-r $SVN_DR/$SVN_REPO"#g' /etc/sysconfig/svnserve
#设置开机启动
systemctl enable svnserve.service 
systemctl start svnserve.service
systemctl restart svnserve.service 
