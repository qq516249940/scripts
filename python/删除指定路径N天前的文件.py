#!/usr/bin/env python
#coding=utf-8
import os
import time
import logging
import sys

# reload(sys)
# sys.setdefaultencoding('utf8')


# fileDir = "E:/"


# 创建一个handler，用于写入日志文件
fh = logging.FileHandler('E:/test.log')
# 创建一个logger
logger2 = logging.getLogger('mylogger')
logger2.setLevel(logging.INFO)
logger3 = logging.getLogger('mylogger')
logger3.setLevel(logging.ERROR)
# 创建一个handler，由于输出到控制台
ch = logging.StreamHandler()
# 定义handler的输出格式formatter
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
fh.setFormatter(formatter)
ch.setFormatter(formatter)
# 给logger添加handler
logger2.addHandler(fh)
logger2.addHandler(ch)
logger3.addHandler(fh)
logger3.addHandler(ch)


def list_show(fileDir):
    """删除N天前的脚本，可以准确到秒，按照时间戳计算，path需要指定路径，n_day需要指明天数。"""
    for eachFile in os.listdir(fileDir):
        # 如果是文件
        if os.path.isfile(fileDir+"/"+eachFile):
            ft = os.stat(fileDir+"/"+eachFile);
            last_m_time = int(ft.st_mtime);
            # print last_m_time;
            n_day_time = int(time.time())-n_day;
            try:

                if last_m_time <= n_day_time:
                    print "我要删除的文件是:  "+fileDir+"/"+eachFile;
                    # os.remove(fileDir+"/"+eachFile);
                    # 记录删除日志
                    logger2.info('delete gitlab backup file info message 我要删除的文件是: %s/%s'% (fileDir,eachFile)) ;
                else:
                    print "没有你要删除的文件"
            # 如果是文件夹，用这个可以递归
        # elif os.path.isdir(fileDir+"/"+eachFile):
        #         listDir(fileDir+"/"+eachFile);
            except IOError,e:
                print e;
                # logger3.error('e') ;


if __name__ == '__main__':
    path = "E:/"
    n_day = 3600*24*3
    print "5s wake up"
    time.sleep(5);
    list_show(path);







