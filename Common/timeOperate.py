import datetime
import os


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

def returnDayTimePng(path,dr):
	"""
		Driver截图并返回
	:param path: str
	:param dr: driver
	:return:
	"""
	dateFile = path + returnYearMounthDay()
	if not os.path.exists(dateFile):  # 判断是否存在文件夹如果不存在则创建为文件夹
		os.makedirs(dateFile)
	Png = dateFile + '/' + returnTime() + '.png'
	dr.get_screenshot_as_file(Png)
	return Png

