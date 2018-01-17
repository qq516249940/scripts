# -*- coding: utf-8 -*-
import sys
reload(sys)
sys.setdefaultencoding('utf-8')
'''
原作者：昨夜星辰  修改：chunk
注意事项：该脚本只能在Linux环境用Python 2.x运行，如需在其他环境运行请读者自行修改。
添加了异常try except，和time
'''
import re
import os
import shutil
import requests
from bs4 import BeautifulSoup
import time

# 创建文件夹，若已存在则删除，再创建。
def create_folder(path):
    if os.path.exists(path):
        if os.path.isdir(path):
            pass
            # shutil.rmtree(path)
        else:
            pass
            # os.remove(path)
    try:
      os.mkdir(path)
    except:
      print "文件夹已经存在"
# 询问用户
def ask_user(string):
    while True:
       # answer = raw_input(string)
        answer = "Y"
        if answer == 'Y':
            return True
        elif answer == 'N':
            return False
        else:
            print '输入有误，请重新输入！'

# 创建根目录
root_folder = '淘宝女郎'
create_folder(root_folder)

# 遍历每位淘女郎
url = 'https://mm.taobao.com/json/request_top_list.htm?page=2'
bs1 = BeautifulSoup(requests.get(url).text, 'lxml')
for top in bs1('p', 'top'):
    name = top.find('a').text
    age = top.find('em').text
    city = top.find('span').text
    user_id = top.find('span', 'friend-follow J_FriendFollow')['data-userid']
    print '发现一位美眉，她叫做%s，今年%s，住在%s，现在开始爬取她的个人页面……' % (name, age, city)

    # 以淘女郎的昵称新建文件夹
    mm_folder = '%s/%s' % (root_folder, name)
    create_folder(mm_folder)

    # 获取淘女郎的个人资料并保存到文件
    url = 'https://mm.taobao.com/self/info/model_info_show.htm?user_id=' + user_id
    bs2 = BeautifulSoup(requests.get(url).text, 'lxml')
    base_info = bs2.find('ul', 'mm-p-info-cell clearfix')
    info_list = base_info('span')
    result = []
    result.append('昵称：' + info_list[0].text)
    result.append('生日：' + info_list[1].text.strip())
    result.append('所在城市：' + info_list[2].text)
    result.append('职业：' + info_list[3].text)
    result.append('血型：' + info_list[4].text)
    result.append('学校/专业：' + info_list[5].text)
    result.append('风格：' + info_list[6].text)
    result.append('身高：' + base_info.find('li', 'mm-p-small-cell mm-p-height').find('p').text)
    result.append('体重：' + base_info.find('li', 'mm-p-small-cell mm-p-weight').find('p').text)
    result.append('三围：' + base_info.find('li', 'mm-p-small-cell mm-p-size').find('p').text)
    result.append('罩杯：' + base_info.find('li', 'mm-p-small-cell mm-p-bar').find('p').text)
    result.append('鞋码：' + base_info.find('li', 'mm-p-small-cell mm-p-shose').find('p').text)
    print '资料收集完毕，正在保存她的个人资料……',
    filename = '%s/%s.txt' % (mm_folder, name)
    with open(filename, 'w') as f:
        f.write('\r\n'.join(result))
    print '保存完毕！'

    # 获取相册的总页数
    url = 'https://mm.taobao.com/self/album/open_album_list.htm?_charset=utf-8&user_id%20=' + user_id
    bs3 = BeautifulSoup(requests.get(url).text, 'lxml')
    album_total_page = int(bs3.find('input', id='J_Totalpage')['value'])

    # 遍历每一页
    for album_page in range(1, album_total_page + 1):
        url = 'https://mm.taobao.com/self/album/open_album_list.htm?_charset=utf-8&user_id%%20=%s&page=%d' % (user_id, album_page)
        bs3 = BeautifulSoup(requests.get(url).text, 'lxml')
        album_count = 1

        # 遍历每一个相册
        for album_area in bs3('div', 'mm-photo-cell-middle'):
            # 获取相册的链接、id、名称和照片数
            album_url = 'https:' + album_area.find('h4').find('a')['href']
            album_id = re.search(r'album_id=(\d+)', album_url).group(1)
            album_name = album_area.find('h4').find('a').text.strip()
            pic_num = album_area.find('span', 'mm-pic-number').text
            pic_num = re.search(r'\d+', pic_num).group(0)
            print '现在开始爬取她的第%d个相册，相册名为：《%s》(%s张)……' % (album_count, album_name, pic_num)

            # 根据照片数计算总页数
            total_page = int(pic_num) / 16 + 1

            # 以相册名新建文件夹
            album_folder = '%s/%s' % (mm_folder, album_name)
            create_folder(album_folder)

            pic_count = 1
            # 遍历每一页
            for page in range(1, total_page + 1):
                url = 'https://mm.taobao.com/album/json/get_album_photo_list.htm?user_id=%s&album_id=%s&page=%s' % (user_id, album_id, page)
                try:
                  json = requests.get(url).json()
                except:
                  try:
                    time.sleep(60)
                    json = requests.get(url).json()
                  except:
                    print "连接断开"
                  
                try: 
                  for pic in json['picList']:
                      print '现在开始下载该相册的第%d张照片……' % pic_count,
                      pic_url = 'https:' + pic['picUrl']
                      pic_url = re.sub(r'290', '620', pic_url)
                      filename = '%s/%s.jpg' % (album_folder, pic_count)
                      with open(filename, 'wb') as f:
                          f.write(requests.get(pic_url).content)
                      print '下载完毕！'
                      pic_count += 1
                except:
                      pic_count += 1
            if ask_user('该相册已经下载完毕，是否下载下一个相册？（Y/N）') == False:
                break
            album_count += 1
        if ask_user('当前页的相册已经下载完毕，是否下载下一页？（Y/N）') == False:
            break
