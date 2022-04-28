# 更新说明
## 版本0.0.1
* 支持FIO自动化测试磁盘、绘制实时IO图、最大值折线图并自动化生成测试报告。
* 通用接口自动化测试函数
* 通用UI自动化测试函数
## 版本0.0.2
* 增加CHANGELOG
* 增加磁盘自动化测试时获取测试设备硬件信息
* 支持所有dev目录下磁盘设备自动化磁盘测试
## 版本0.0.3
* 支持使用多个客户端进行联机磁盘、文件系统性能自动化测试并生成结果
* 利用python虚拟化解决版本包冲突问题



# 缺陷及优化

### 已知缺陷
* ~~iops/带宽值小于4的情况下无法生成barfix 21-0428）~~
* ~~图片路径不能复原（fix 21-0428）~~
* ~~没有转换KB/s为MB/s(fix 21-0521)~~
* ~~特殊数值导致bar脚本无法复原（fix 21-0429）~~
* ~~iops带k情况下最大值取不到的问题（fix 21-0505）~~
* ~~根据文件生成折线图IOPS图存在取值错误（fix 21-0520）~~
* ~~linux下无SimHei问题(fix 21-0521)~~
* 利用封装组件zCharts做出来的图纵坐标无法显示

### 待优化/处理、计划
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
* 深入了解Locust机制
* requests 库性能不佳，打算更改测试工具为Boomer（Golang）
* Locust报告模块优化
* ~~fio测试脚本向下兼容（目前仅支持3.16版本的fio）~~
* fio脚本\`命令定义在配置文件或头部
* 整合全部类型的fio脚本
* ~~vdbench脚本用运行Python~~
* 增加PC端自动化测试框架（采用pyautogui或pywinauto待定）
* epbf调研与基础应用以分析性能瓶颈
* fio联机测试调研
* 实例一个测试流程

### 异常处理

* 现象：fio读写提示：fio: failed allocating random map. If running a large number of jobs, try the 'norandommap' option or set 'softrandommap'. Or give a larger --alloc-size to fio.
fio参数中增加：norandommap

* 现象：运行matplotlib提示：matplotlib display text must have all code points < 128 or use Unicode strings
追加`import sys
reload(sys)
sys.setdefaultencoding('utf-8')`