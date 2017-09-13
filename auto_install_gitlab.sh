#!/bin/bash
#1、安装配置依赖项

#如想使用Postfix来发送邮件,在安装期间请选择'Internet Site'. 您也可以用sendmai或>者 配置SMTP服务 并 使用SMTP发送邮件.
# 
#在 Centos 6 和 7 系统上, 下面的命令将在系统防火墙里面开放HTTP和SSH端口.

sudo yum install curl policycoreutils openssh-server openssh-clients git -y
sudo systemctl enable sshd
sudo systemctl start sshd
sudo yum install postfix -y
sudo systemctl enable postfix
sudo systemctl start postfix
#sudo firewall-cmd --permanent --add-service=http
#sudo systemctl reload firewalld

#2. 添加GitLab仓库,并安装到服务器上
#curl -sS http://packages.gitlab.cc/install/gitlab-ce/script.rpm.sh | sudo bash
curl -LJO https://mirrors.tuna.tsinghua.edu.cn/gitlab-ce/yum/el7/gitlab-ce-9.2.2-ce.0.el7.x86_64.rpm
rpm -i gitlab-ce-9.2.2-ce.0.el7.x86_64.rpm

#启动GitLab
echo "please input gitlab-ctl reconfigure"
echo  "请输入sudo gitlab-ctl start"
#sudo gitlab-ctl reconfigure
#sudo gitlab-ctl start
