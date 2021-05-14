from selenium import webdriver
from Config.currency import TESTPATH
from selenium.webdriver.chrome.options import Options
import os
import time

def openWebdriverMax():
	dr = webdriver.Chrome(r'../Tools/Webdriver/chromedriver.exe')
	# 最大化
	dr.maximize_window()
	# 隐性等待10S
	dr.implicitly_wait(10)
	return dr

def openWebdriverNoUI():

	# 无界面模式开始
	chrome_options = Options()
	chrome_options.add_argument('--headless')
	chrome_options.add_argument('--disable-gpu')
	# 定义路径
	dr = webdriver.Chrome(r'../Tools/Webdriver/chromedriver.exe', chrome_options=chrome_options)
	return dr




if __name__=='__main__':

	# dr = openWebdriverMax()
	# #dr.get("https://www.baidu.com/")
	# dr.get("file:" + TESTPATH +"/Demo/DiskPerformanceReport/indexDemo.html")
	# dr.close()
	dr = openWebdriverNoUI()




