#!/usr/bin/env python
#coding=utf-8

import os
import paramiko
import  datetime
import  sys

def last_backup_file():
    file_dir = u"/root/downloads"
    list = os.listdir(file_dir)
    list.sort(key=lambda fn: os.path.getmtime(file_dir+fn) if not os.path.isdir(file_dir+fn) else 0)
    d=datetime.datetime.fromtimestamp(os.path.getmtime(file_dir+list[-1]))
    print('最后改动的文件是'+list[-1]+"，时间："+d.strftime("%Y-%m-%d %H-%M-%S"))

def sftp_download():

    paramiko.util.log_to_file('./paramiko.log')

    # Open a transport

    host = "10.0.xxx.xxx"
    port = 22
    transport = paramiko.Transport((host, port))

    # Auth

    username = "root"
    # password = "xxxxxx"
    privatekeyfile = os.path.expanduser("F:\\key/id_rsa")
    mykey = paramiko.RSAKey.from_private_key_file(privatekeyfile,password=None)

    try:
      # transport.connect(username = username, password = password)
      transport.connect(username = username, pkey=mykey)
    except Exception,e:
        print e

    # Go!
    ssh = paramiko.SSHClient()
    ssh._transport = transport
    sftp = paramiko.SFTPClient.from_transport(transport)


    # find last backup file
    stdin, stdout, stderr = ssh.exec_command("ls -t /data/gitlab_backups")
    downfile1 = stdout.readline()
    downfile = downfile1.strip()

    print downfile

    # for myfile in stdout.readlines[0]:
    #   print myfile
    # Download


    filepath = '/data/gitlab_backups/'+str(downfile)
    print filepath
    localpath = './remotepasswd.tar'
    try:
      sftp.get(filepath, localpath)
      print "传输成功"
    except Exception,e:
        print e

    # Upload

    # filepath = '/home/foo.jpg'
    # localpath = '/home/pony.jpg'
    # sftp.put(localpath, filepath)

    # Close

    sftp.close()
    transport.close()

if __name__=="__main__":
    # last_backup_file()
    sftp_download()




