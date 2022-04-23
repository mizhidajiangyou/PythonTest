import os

from Config.performance import diskList
from Common.timeOperate import zSleep, returnYearMounthDay

if __name__ == '__main__':
	# 测试日期
	testDay = returnYearMounthDay()
	# 运行服务端卷分配
	os.system('python3 clientReady.py')
