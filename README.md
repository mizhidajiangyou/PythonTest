# 自动化测试
疑问及建议可发送邮件至：mizhidajiangyou@163.com

[环境](#环境)

[接口自动化测试](#接口自动化测试)

[UI自动化测试](#UI自动化测试)

[接口性能自动化测试](#接口性能自动化测试)

[磁盘性能自动化测试](#磁盘性能自动化测试)

[PC端自动化测试](#PC端自动化测试)

[测试服务器](#测试服务器)

## 正常使用
* docker pull xxxx(准备中)

* 执行Shell/z-env.sh 以完成linux场景下的环境变量配置,windows场景下自行配置ZHOME系统变量

* 在TestCase_Pytest下创建test开头的Py文件

* 根据需要引用Common里的函数可实现ui、接口、性能等自动化测试，可参照Demo文件中的一些模板。

* 参照Demo的runner.py生成基于allure的测试报告

## 依赖
`pip install matplotlib`

`pip install pytest`

`pip install allure-pytest`

`git clone https://github.com/locustio/locust.git && python setup.py install`

1.5版本使用注意事项: https://docs.locust.io/en/latest/quickstart.html

Vue3.0 :`<script src="https://unpkg.com/vue@next"></script>`
ElementPlus:`<link rel="stylesheet" href="https://unpkg.com/element-plus/lib/theme-chalk/index.css">`
`<script src="https://unpkg.com/element-plus/lib/index.full.js"></script>`
* 可通过Tools/Web/downloadUnpkg.py文件将依赖下载至本地（默认将下载最新版本[-1]，默认存放Tools/Web路径（./））

`pip install Selenium`
Chrome：https://chromedriver.storage.googleapis.com/index.html?path=91.0.4472.19/
Firefox：https://github.com/mozilla/geckodriver/releases

`pip install pytest-shutil`

`pip install pymongo`

`pip install pymysql`

`pip install Django -i https://pypi.tuna.tsinghua.edu.cn/simple`

## 环境

### log支持中文
修改FileHandler => def __init__(self, filename, mode='a', encoding='utf-8', delay=False)
    
### 使用pytest
左上角file->Setting->Tools->Python Integrated Tools->项目名称->Default test runner->选择py.test

### 使用allure
1. 下载：https://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/2.13.9/
2. path中添加

### linux解决SimHei问题
1、import matplotlib print(matplotlib.matplotlib_fname()) 获取路径；
2、拷贝至mpl-data/fonts/ttf 
3、删除缓存：rm ~/.cache/matplotlib -rf（注意：可能缓存地址不对，使用代码 fontmanager.get_cachedir() 或 fontmanager._fmcache获取缓存地址。） 
4、plt.rcParams['font.sans-serif']=['SimHei']  

### MongoDB
MongoDB：https://www.mongodb.com/try/download/community 
* linux：选择TGZ下载， 解压tar -zxvf mongodb-linux.tgz；改名为mongodb；;加入环境变量：export PATH=<mongodb-install-directory>/bin:$PATH；cd mongodb &&mkdir -p data/db；运行./mongod --port 27017 --dbpath=/data/mongodb/data/db --logpath=/data/mongodb/logs --fork;查看ps -ef
* Windows：下载msi安装；在data目录下创建db、log

## 接口自动化测试

## UI自动化测试

### 模块构成
Common、Report/UI、TestCase

### 核心模块

#### 元素操作模块
elementOperate.py

##### 功能说明
* 提供异常处理，重试次数，重试间隔在Config/currency中设置
* 提供css_selector、xpath、id三种方法搜索元素
* 封装元素click、sendkeys、clear等操作
* 提供异常情况下截图并存放UI/ErrorPng
* 提供全屏截图功能

## 接口性能自动化测试
使用Locust，模版放置Demo。 待封装待优化。
### 模块构成

## 磁盘性能自动化测试 
目前支持fio和vdbench2种工具自动化测试

### 模块构成
Performance、Shell/fio、Shell/vdbench、Report/DiskPerformance、Common、Demo/DiskPerformanceReport

### 核心模块

#### vdbench自动测试模块
Shell/vdbench/run-vdbench.sh
支持在linux任意目录运行该脚本，可多客户机运行。

##### 功能及参数说明
./run-vdbench.sh --help 查看帮助信息，以修改自动生成的vdbench测试脚本配置。
默认自动生成FC的vdbench脚本，并自动执行标准化的4K、1M，随机、顺序，读、写性能测试。

    <--brand| --mode| --type| --ip> \n
    (--Ldisk)\n
    [--size| --rdpct| --block| --fileio| --seekpct] \n
    [--runtime| --interval| --warmup | --pause] \n
    [--file| --out| --log| --date] \n
    brand     <string>            disk manufacturer;default SEAGATE
    mode      <int>               whether which run mode you test;default 2
              *   0               scan and test
              *   1               test and make report
              *   2               nohup run vdbench &
              *   3               only use your output to make picture report
              *   4               ssh no password
              *   5               use parameter \"command\" to run bash in all client
    type      <string>            whether which volume type you test;default fc
              *   fc              must install device-mapper-multipath(multipath-tools)
              *   iscsi           must install iscsi
              *   nfs             must install nfs-utils
              *   cifs            default support
              *   Ldisk           test every client local disk whitch you  appoint
              *   Lfile           test every client local file system  whitch you  appoint
    disk      <\"array\">           when the type is Ldisk must to define;no default.
    ip        <\"array\">           all ip list which you want to test;default ssh ip
    size      <int>               disk or file size;default 500
    rdpct     <\"array\">           percentage of read ;default \"0 100\"
    block     <\"array\">           test block size ;default \"4k 1M\"
    fileio    <\"array\">           test fileio ;default \"random sequential\"
    seekpct   <\"array\">           test random ratio ;default \"100 0\"
    runtime   <int>               test runtime(s) ;default 300
    interval  <int>               print interval(s) ;default 1
    warmup    <int>               hot start time(s) ;default 30
    pause     <int>               pause time(s) ;default 30
    fdepth    <int>               fsd default file depth
    fwidth    <int>               fsd default file width
    fnum      <int>               fsd default file num
    fsize     <int>               fsd default file size (MB)
    file      <\"path\">            *.vbd will put in;default pwd
    out       <\"path\">            vdbench out put will put in;default pwd/vd-output
    log       <\"path\">            run logs will put in;default same with file
    date      <date>              date for test ,like 220101;default date '+%y%m%d'
    command   <string>            the command in ssh \"ip\" bash \"command\"
    
#### FIO自动化测试模块
Shell/zfioPerformance.sh
仅支持在本目录运行，待优化项较多，目前仅支持单机运行。

##### 功能及参数说明

    $1 参数1位类型
    $2 参数2为名称
    $3 参数3设定执行方式
    $4 测试磁盘是需使用参数4表示盘符

#### 报告生成模块
Common/fileOperate.py、reOperate.py
目前仅支持fio报告

##### 功能说明
* 根据地址、本次测试数据，生成HTML、JS、CSS（基于ElementPlus）
* `待选择，2种方案`[每次报告的数据会生成一个json格式文件/直接读取json文件并作出修改] 然后替换mainDemo.js中的内容再去生成js文件
* 使用selenium对生成的HTML进行全屏截图，保存文件即为测试报告

#### 图片生成模块
Performance/bar.py
Performance/makelines.py
支持fio（利用sysstat获取实时io；）vdbench（工具自身统计实时io）2种工具测试场景下，精确到s的IO折线图生成与最终测试结果的柱状图、折线图生成。
部分效果图见Report/DiskPerformance/2021-05-26/
效果：
![Image text](https://github.com/mizhidajiangyou/myTest/blob/performance/Report/DiskPerformance/2021-05-26/linepng-IOPS-2021-05-21.png)

Common/elementOperate.py
效果：<img src="https://github.com/mizhidajiangyou/myTest/blob/performance/Report/DiskPerformance/2021-05-26/all.png" width="100" height="200" />

Performance/IOLines.py
![Image text](https://github.com/mizhidajiangyou/myTest/blob/performance/Report/DiskPerformance/2021-05-26/disk-write.png)
##### 柱状图

##### 折线图

## PC端自动化测试

### 模块构成

### 核心模块

#### 元素操作模块


##### 功能说明


## 测试服务器
使用的linux系统为Ubuntu20.04

### 搭建

#### 一、ubuntu20.04系统部署
* IP配置
`vim /etc/netplan/xxxxx.yaml`

添加：
   network:
  ethernets:
    enp7s0f0:
      addresses:
      - 10.18.18.23/24
      gateway4: 10.18.18.1
      
  version: 2
 
 `netplan apply`

* 源配置 
`deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal main restricted universe multiverse`
`deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-security main restricted universe multiverse`
`deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-updates main restricted universe multiverse`
`deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-proposed main restricted universe multiverse`
`deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-backports main restricted universe multiverse`
`https://mirror.tuna.tsinghua.edu.cn/help/ubuntu/`
* ssh启用
一般只会安装客户端，所以需要安装服务端（）
`sudo apt install openssh-server`

-> LoginGraceTime 2m
-> PermitRootLogin yes
-> StrictModes yes

#### 二、Apache2部署

* 安装apache2 `apt-get install apache2`

* 启动服务 /etc/init.d/apache2 restart/start/stop && apache2ctl -k  restart/start/stop

* 修改html根目录：/etc/apache2/sites-available/000-default.conf中的 DocumentRoot 对应的目录

* 修改html文件对应：/etc/apache2/mods-available/dir.conf（可不做）

#### 三、Django部署
* python manage.py runserver

* django-admin startproject MySite

* 修改MySite/settings => TIME_ZONE = 'Asia/Shanghai';LANGUAGE_CODE = 'zh-hans' ;USE_TZ = False

* 在init文件中追加 `import pymysql;pymysql.install_as_MySQLdb()`

* mysql配置：grant all privileges on test1.* to 'django'@'localhost' identified by 'password';

* settings配置文件修改：`DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'test1',
        'USER': 'django',
        'PASSWORD': 'password',
        'HOST': 'localhost',
        'PORT': '3306',
    }
}`

* `python manage.py migrate` # 创建表结构

*  ORM模型：app(django-admin startapp)>>models中配置：`类名<->表名` ; `实例<->记录` ;`属性<->字段` 追加`class Question(models.Model):
    question_text = models.CharField(max_length=200)`

* setting.py配置文件修改：`INSTALLED_APPS = [
    'polls'
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
]`

* `python manage.py makemigrations` # 模型变更

* `python manage.py migrate polls` # 根据模型创建表













