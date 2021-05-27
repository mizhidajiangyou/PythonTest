# 自动化测试
疑问及建议可发送邮件至：670746945@qq.com 或直接添加

[环境](#环境)

[接口自动化测试](#接口自动化测试)

[UI自动化测试](#UI自动化测试)

[接口性能自动化测试](#接口性能自动化测试)

[磁盘性能自动化测试](#磁盘性能自动化测试)

[测试服务器](#测试服务器)

[缺陷及优化](#缺陷及优化)


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

`pip install Django -i https://pypi.tuna.tsinghua.edu.cn/simple`

## 环境

### 环境变量
`parent_path = os.path.dirname(sys.path[0]) 
if parent_path not in sys.path:
    sys.path.append(parent_path)`

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

### 已知缺陷

### 待优化

## 接口性能自动化测试
使用Locust，模版放置Demo。 待封装待优化。
### 模块构成

### 待优化
* 深入了解Locust机制
* requests 库性能不佳，打算更改测试工具为Boomer（Golang）
* Locust报告模块优化

### 已知缺陷


## 磁盘性能自动化测试 

### 模块构成
Performance、Shell、Report/DiskPerformance、Common、Demo/DiskPerformanceReport

### 核心模块

#### 报告生成模块
Common/fileOperate.py、reOperate.py

##### 功能说明
* 根据地址、本次测试数据，生成HTML、JS、CSS（基于ElementPlus）
* `待选择，2种方案`[每次报告的数据会生成一个json格式文件/直接读取json文件并作出修改] 然后替换mainDemo.js中的内容再去生成js文件
* 使用selenium对生成的HTML进行全屏截图，保存文件即为测试报告

#### 图片生成模块
Performance/bar.py
Performance/makelines.py
效果：
![Image text](https://github.com/mizhidajiangyou/myTest/blob/performance/Report/DiskPerformance/2021-05-26/linepng-IOPS-2021-05-21.png)

Common/elementOperate.py
效果：<img src="https://github.com/mizhidajiangyou/myTest/blob/performance/Report/DiskPerformance/2021-05-26/all.png" width="100" height="200" />

##### 柱状图

##### 折线图
根据生成的max文件

#### 测试模块
Shell/zfioPerformance.sh

##### 功能及参数说明


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

* django-admin startproject MySite




## 缺陷及优化

### 已知缺陷
* ~~iops/带宽值小于4的情况下无法生成barfix 21-0428）~~
* ~~图片路径不能复原（fix 21-0428）~~
* ~~没有转换KB/s为MB/s(fix 21-0521)~~
* ~~特殊数值导致bar脚本无法复原（fix 21-0429）~~
* ~~iops带k情况下最大值取不到的问题（fix 21-0505）~~
* ~~根据文件生成折线图IOPS图存在取值错误（fix 21-0520）~~
* ~~linux下无SimHei问题(fix 21-0521)~~

### 待优化
* Linux环境下支持中文
* 传参问题，以精简代码
* ~~图表生成~~
* ~~$3支持选择执行步骤~~
* ~~最大值生成~~
* bw、iops判断大小的优化
* ~~根据最大值max文件生成折线图~~
* 直接输出磁盘性能测试最终报告
* 优化整体框架，搭建ubuntu测试磁盘性能web服务器（mongdb+Apache2+vue+python+shell），以实现动态的一键测试及报告产出
* 折线图（makelines.py）中num数组生成方式
* ~~indexDemo.html中的数据来源~~
* ~~fio中磁盘参数动态获取~~

### 异常处理

* 现象：











