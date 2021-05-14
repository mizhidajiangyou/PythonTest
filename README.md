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

`pip install Selenium`

Chrome：https://chromedriver.storage.googleapis.com/index.html?path=91.0.4472.19/
Firefox：https://github.com/mozilla/geckodriver/releases

`pip install PIL numpy`

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

### 已知缺陷

### 待优化

## 接口性能自动化测试
使用Locust，模版放置Demo。 待封装待优化。
### 模块构成

### 待优化
* 深入了解Locust机制
* requests 库性能不佳，打算更改测试工具为Boomer（Golang）
* Locust报告模块优化


## 磁盘性能自动化测试 

### 模块构成
Performance、Shell、Report/DiskPerformance

### 核心模块

#### 图片生成模块
Performance/bar.py
Performance/makelines.py

##### 柱状图

##### 折线图

###### 待优化
num数组生成方式

#### 测试模块
Shell/zfioPerformance.sh

##### 功能及参数说明

### 已知缺陷
* ~~iops/带宽值小于4的情况下无法生成barfix 21-0428）~~
* ~~图片路径不能复原（fix 21-0428）~~
* 没有转换KB/s为MB/s
* ~~特殊数值导致bar脚本无法复原（fix 21-0429）~~
* ~~iops带k情况下最大值取不到的问题（fix 21-0505）~~

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






