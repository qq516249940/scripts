#挂载路径　	分区格式	分区大小	备注信息
#swap分区	---	内存的2倍	交换分区，如果是虚拟机可以不创建
#/boot	---	500MB	启动分区，如果不分配磁盘被占满会无法启动系统
#/	ext4	剩余空间	后续有其他需求，可以增加磁盘独立创建分区
#kdump：一般用不着关闭即可

#创建工作目录
create_work_path() {
	mkdir -p /opt/{tools,shell}
	mkdir -p /data/{backup,web}
}

#配置阿里云 base 源，不常用
install_ali_base() {
	mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
	curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
	cat /etc/yum.repos.d/CentOS-Base.repo
}

#配置阿里云 epel 源，yum 下载慢可以使用，一般使用默认官方源
install_ali_epel() {
	mv /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo.backup
	mv /etc/yum.repos.d/epel-testing.repo /etc/yum.repos.d/epel-testing.repo.backup
	curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
	cat /etc/yum.repos.d/epel.repo
}

#安装常用工具
install_tools() {
	yum clean all
	yum makecache fast
	yum -y install epel-release vim wget curl yum-utils bash-completion bash-completion-extras lrzsz telnet -y
	yum install gcc gcc-c++ cmake pcre pcre-devel zlib zlib-devel openssl openssl-devel vim wget telnet setuptool lrzsz dos2unix net-tools bind-utils tree screen iftop ntpdate lsof iotop -y
	yum groupinstall "Development tools" -y
}

##配置 TIME_WAIT 参数，清理超时连接
#netstat -anptl|grep TIME_WAIT|wc -l
#echo " " >> /etc/sysctl.conf
#echo "# made by zhaoshuai for kill time_wait on $(date +%F)." >> /etc/sysctl.conf
#echo "net.ipv4.tcp_syncookies = 1" >> /etc/sysctl.conf
#echo "net.ipv4.tcp_tw_reuse = 1" >> /etc/sysctl.conf
#echo "net.ipv4.tcp_tw_recycle = 1" >> /etc/sysctl.conf
#echo "net.ipv4.tcp_fin_timeout = 30" >> /etc/sysctl.conf
#echo "net.ipv4.tcp_orphan_retries = 2" >> /etc/sysctl.conf
#echo "net.ipv4.ip_local_port_range = 1024 65000" >> /etc/sysctl.conf
#tail -8 /etc/sysctl.conf
#sysctl -p
#netstat -anptl|grep TIME_WAIT|wc -l

##让系统自动回收内存 cache
#echo " ">>/etc/sysctl.conf
#echo "# Automatic recovery memory on $(date +%F)">>/etc/sysctl.conf
#echo "vm.extra_free_kbytes=209196">>/etc/sysctl.conf
#sysctl -p

#setenforce 0
#
sed -i s#SELINUX=enforcing#SELINUX=disabled#g /etc/selinux/config
setenforce 0
cat /etc/selinux/config | grep SELINUX=disabled

add_pubkeys() {
	echo "youkey" >>/root/.ssh/authorized_keys
	sed -i "s/#PubkeyAuthentication yes/PubkeyAuthentication yes/g" /etc/ssh/sshd_config
	sed -i "s/^PasswordAuthentication yes/PasswordAuthentication no/g" /etc/ssh/sshd_config
	systemctl restart sshd
}

install_jdk1.8() {
	cd /usr/local/src/
	wget https://github.com/frekele/oracle-java/releases/download/8u212-b10/jdk-8u212-linux-x64.tar.gz
	tar -zxf jdk-8u212-linux-x64.tar.gz -C /usr/local/
	#install java
	alternatives --install /usr/bin/java java /usr/local/jdk1.8.0_212/bin/java 2
	alternatives --config java

	echo "export JAVA_HOME=/usr/local/jdk1.8.0_212" >> /etc/profile 
	echo "export JER_HOME=/usr/local/jdk1.8.0_212/jre" >> /etc/profile 
	echo "export PATH=JAVA_HOME/bin:JER_HOME/bin:$PATH" >> /etc/profile 
	echo "export  CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar:$JRE_HOME/lib" >> /etc/profile 
	
	
	echo "#################cat success#######################################"
    source /etc/profile
    echo "#################JDK is installed###############################"

}

install_ntp() {
	yum install ntp -y
	timedatectl set-ntp true
	timedatectl set-timezone "Asia/Shanghai"
}

install_docker() {
	wget -O - https://github.com/docker/docker-install/raw/master/install.sh | bash
	systemctl restart docker
	echo '{"graph": "/data/docker"}' >/etc/docker/daemon.json
	systemctl restart docker
	systemctl enable docker
}

install_zabbix-agent() {
	rpm -ivh https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm
	#安装yum-config-manager
	yum -y install yum-utils
	yum-config-manager --enable rhel-7-server-optional-rpms
	yum install zabbix-agent -y
	sed -i 's/127.0.0.1/148.66.11.55/g' /etc/zabbix/zabbix_agentd.conf
	sed -i "s/Hostname=Zabbix server/Hostname=${HOSTNAME}/g" /etc/zabbix/zabbix_agentd.conf
	grep "^\s*[^# \t].*$" /etc/zabbix/zabbix_agentd.conf
	systemctl start zabbix-agent.service && systemctl enable zabbix-agent.service
}

init_set_hostname() {
	echo "Hello, please input your hostname!!!!!!!!!!!!!!!!!!!!!!!!"
	read -p 'Hostname is: ' varname
	hostnamectl set-hostname $varname
	echo "you hostname is $varname"
}

menu ()
{
 cat << EOF
----------------------------------------
|***************菜单主页***************|
----------------------------------------
`echo -e "\033[35m 1)init_set_hostname\033[0m"`
`echo -e "\033[35m 2)install_zabbix-agent\033[0m"`
`echo -e "\033[35m 3)install_jdk1.8\033[0m"`
`echo -e "\033[35m 4)install_zabbix-agent\033[0m"`
`echo -e "\033[35m 5)install_docker\033[0m"`
`echo -e "\033[35m 5)add_pubkeys\033[0m"`
`echo -e "\033[35m 6)menu\033[0m"`
`echo -e "\033[35m 7)退出\033[0m"`
EOF
read -p "请输入对应产品的数字：" num1
case $num1 in
 1)
  echo "init_set_hostname!!"
  init_set_hostname
  ;;
 2)
  echo "install_zabbix-agent!!"
  install_zabbix-agent
  ;;
 3)
  echo "install_jdk1.8!!"
  install_jdk1.8
  ;;
 4)
  echo "install_zabbix-agent!!"
  install_zabbix-agent
  ;;  
 5)
  echo "install_docker!!"
  install_docker
  ;; 
 6)
  clear
  menu
  ;;
 7)
   exit 0
esac
}

create_work_path
#init_set_hostname
install_tools
install_ntp
#install_jdk1.8
#install_zabbix-agent
#install_docker
#add_pubkeys

menu

echo "脚本执行完毕!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
