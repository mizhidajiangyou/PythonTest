import os
import sys
import time

parent_path = os.path.dirname(sys.path[0])
if parent_path not in sys.path:
	sys.path.append(parent_path)

from Config.performance import diskList
from Common.timeOperate import zSleep

if __name__ == "__main__":
	"""
		请务必保证配置文件中的盘符是要测试的盘符。
	"""
	# 生成日期配置文件
	os.system("echo `date +$Y-%m-%d` >> ../TestData/day.date")


	testList = diskList.split()
	# 测试裸盘
	os.system("cd ../Shell && sh chmod777.sh")
	for i in testList:
		os.system("cd ../Shell && ./zfioPerformance.sh disk TEST-DISK 1 " + i)

	# 整机测试
	os.system("cd ../Shell && ./zfioPerformance.sh disk TEST-ENTIRE-DISK 1 entire")

	# 创建zpool
	os.system("cd ../Shell &&./zpoolCreate.sh")
	zSleep("m")

	for i in testList:
		i = "a" + i

		os.system("cd ../Shell && ./zfioPerformance.sh disk TEST-DISK 1 " + i)

	os.system("ls -al")

	os.system("rm ../TestData/day.date")


