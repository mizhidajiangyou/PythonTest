import os
import sys
import time

parent_path = os.path.dirname(sys.path[0])
if parent_path not in sys.path:
	sys.path.append(parent_path)

from Config.performance import diskList

if __name__ == "__main__":
	"""
		请务必保证配置文件中的盘符是要测试的盘符。
	"""

	testList = diskList.split()
	# 测试裸盘
	os.system("cd ../Shell && sh chmod777.sh")
	for i in testList:
		os.system("cd ../Shell && ./zfioPerformance.sh disk TEST-DISK 1 " + i)

	# 创建zpool
	os.system("cd ../Shell &&./zpoolCreate.sh")
	for i in testList:
		i = "a" + i

		os.system("cd ../Shell && ./zfioPerformance.sh disk TEST-DISK 1 " + i)

	os.system("ls -al")
