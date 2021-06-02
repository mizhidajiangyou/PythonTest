from Common.myLog import zLog
from os import path
from Common.timeOperate import returnYearMounthDay

# 脚本路径
TESTPATH=path.abspath('..')

# 磁盘性能测试报告路径
PERFORMANCEPATH=TESTPATH + "\Report\DiskPerformance\Report\\"

# 当日磁盘测试报告路径
PERFORMANCEREPORT=PERFORMANCEPATH + returnYearMounthDay() + "\\"

# TestData目录
TESTDATAPATH=TESTPATH + "\TestData\\"

# 脚本内重试次数定义
retryCount=3

# 定义脚本sleep时间
timeSleep=5

# 通用日志模块实例化
currencylog = zLog()

# 达到最大尝试次数提示语
ErrorMax = "尝试已达" + str(retryCount) + "次，失败！"

jsDate = [{}]


# 定义脚本内等待时间
veryLongTime = 300
longTime = 180
mediumTime = 120
shortTime = 60
littleTime = 30
instantaneous = 10


