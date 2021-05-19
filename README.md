# 自动化测试
[环境](#环境)

[接口自动化测试](#接口自动化测试)

[UI自动化测试](#UI自动化测试)

[接口性能自动化测试](#接口性能自动化测试)

[磁盘性能自动化测试](#磁盘性能自动化测试)


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

##### 柱状图

##### 折线图
根据生成的max文件

#### 测试模块
Shell/zfioPerformance.sh

##### 功能及参数说明

### 已知缺陷
* ~~iops/带宽值小于4的情况下无法生成barfix 21-0428）~~
* ~~图片路径不能复原（fix 21-0428）~~
* 没有转换KB/s为MB/s
* ~~特殊数值导致bar脚本无法复原（fix 21-0429）~~
* ~~iops带k情况下最大值取不到的问题（fix 21-0505）~~
* 根据文件生成折线图IOPS图存在取值错误

### 待优化
* Linux环境下支持中文
* 传参问题，以精简代码
* ~~图表生成~~
* ~~$3支持选择执行步骤~~
* ~~最大值生成~~
* bw、iops判断大小的优化
* ~~根据最大值max文件生成折线图~~
* 直接输出磁盘性能测试最终报告
* 优化整体框架，搭建ubuntu测试磁盘性能web服务器（mongdb+Apache+react+python+shell），以实现动态的一键测试及报告产出
* 折线图（makelines.py）中num数组生成方式
* indexDemo.html中的数据来源





