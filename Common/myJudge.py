from Common.myLog import zLog
from Config.currency import retryCount
from Common.timeOperate import returnDayTime
from Common.openDriver import openWebdriverMax
from time import sleep
# 实例化log模块
judgelog = zLog()

def judgeOS(function, bak):
	try:
		function
		judgelog.logger.info(bak + " successful!")
	except OSError:
		judgelog.logger.info("os error!")
	except IOError:
		judgelog.logger.info("io error!")
	except FileNotFoundError:
		judgelog.logger.info("file not found!")
	except Exception:
		judgelog.logger.info("Exception!")

def findByCSS(cssPath, message, dr):
	# 定义重试次数
	pd = retryCount
	while pd > 0:
		try:
			div = dr.find_elements_by_css_selector(cssPath)
			if div != []:
				judgelog.logger.info("已找到：" + message)
				pd = 0
			else:
				if pd == 1:
					judgelog.logger.error("尝试超过" + retryCount + "次，失败！")
					pd = 0
				else:
					pd -= 1
					surplus = 10 - pd
					errorPng = '../Report/UI/ErrorPng/' + returnDayTime() + '.png'
					dr.get_screenshot_as_file(errorPng)
					judgelog.logger.warning("寻找" + message + "  已尝试" + str(surplus) + "次，错误图片存放位置：" + errorPng)
					sleep(5)
		except:
			judgelog.logger.error("error")
			pd -= 1






if __name__ == '__main__':
	# def testa():
	# 	print("aaaaa")
	dr = openWebdriverMax()
	# judgeOS(testa(), "输出aaa")
	dr.get("https://www.baidu.com/")
	findByCSS("span>input#su", "提交按钮", dr)
	dr.close()
