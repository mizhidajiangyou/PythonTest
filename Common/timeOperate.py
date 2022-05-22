"""
时间相关操作；基础脚本；
"""
import datetime
import os
from time import sleep

def returnMySqlDate():
	date = str(datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"))
	return date

def returnAlldate():
	date = str(datetime.datetime.now().strftime("%Y-%m-%d-%H-%M-%S"))
	return date


def returnDayTime():
	date = str(datetime.datetime.now().strftime("%d-%H-%M-%S"))
	return date


def returnTime():
	date = str(datetime.datetime.now().strftime("%H-%M-%S"))
	return date


def returnYearMounthDay():
	date = str(datetime.datetime.now().strftime("%Y-%m-%d"))
	return date


def returnDayTimePng(path, dr):
	"""
		Driver截图并返回
	:param path: str
	:param dr: driver
	:return:
	"""
	dateFile = path + returnYearMounthDay()
	try:
		if not os.path.exists(dateFile):  # 判断是否存在文件夹如果不存在则创建为文件夹
			os.makedirs(dateFile)
		Png = dateFile + '/' + returnTime() + '.png'
		dr.get_screenshot_as_file(Png)
		return Png
	except:
		print("error!")
		return "error!"


def returnYearMounthDayFile(path):
	"""
		在path路径下生成一个年月日的文件，成功则返回路径名
	:param path:
	:return:
	"""
	dateFile = path + returnYearMounthDay()
	try:
		if not os.path.exists(dateFile):  # 判断是否存在文件夹如果不存在则创建为文件夹
			os.makedirs(dateFile)
		return dateFile
	except:
		return False


def zSleep(zTime):
	# 定义脚本内等待时间
	veryLongTime = 300
	longTime = 180
	mediumTime = 120
	shortTime = 60
	littleTime = 30
	instantaneous = 10
	if zTime == "vl":
		sleep(veryLongTime)
	elif zTime == "l":
		sleep(longTime)
	elif zTime == "m":
		sleep(mediumTime)
	elif zTime == "s":
		sleep(shortTime)
	elif zTime == "i":
		sleep(instantaneous)
	elif zTime == "lt":
		sleep(littleTime)
	else:
		sleep(zTime)

