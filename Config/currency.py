from Common.myLog import zLog

# 脚本内重试次数定义
retryCount=3

# 定义脚本sleep时间
timeSleep=5

# 通用日志模块
currencylog = zLog()

# 达到最大尝试次数提示语
ErrorMax = "尝试已达" + str(retryCount) + "次，失败！"



