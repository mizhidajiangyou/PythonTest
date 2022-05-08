from Config.currency import retryCount,currencyLog
from Common.timeOperate import *
from Common.openDriver import openWebdriverMax
from time import sleep

# 实例化log模块
judgelog = currencyLog


def judgeOS(func, bak):
	try:
		func
		judgelog.logger.info(bak + " successful!")
	except OSError:
		judgelog.logger.info("os error!")
	except IOError:
		judgelog.logger.info("io error!")
	except FileNotFoundError:
		judgelog.logger.info("file not found!")
	except Exception:
		judgelog.logger.info("Exception!")


def judgeFindWay(path, way, dr):
	"""
	:Usage:
		判断寻找element的方式并返回查询结果，若查不到则返回控数组
	:param path: str 具体路径
	:param way: str css/xpath/id（三种查询方式）
	:param dr: driver
	:return:  查询结果
	"""
	# 定义返回初始值
	ele = []
	if way == "css":
		ele = dr.find_element_by_css_selector(path)
	elif way == "xpath":
		ele = dr.find_element_by_xpath(path)
	elif way == "id":
		ele = dr.find_element_by_id(path)
	else:
		judgelog.logger.error("error way for find elements")
	return ele








if __name__ == '__main__':
	# def testa():
	# 	print("aaaaa")
	dr = openWebdriverMax()
	# judgeOS(testa(), "输出aaa")
	dr.get("https://www.baidu.com/")
	#findElement("span>input#su", "提交按钮", "css", dr)
	#findElementAndClick("span>input#su", "提交按钮", "css", dr)
	dr.close()
