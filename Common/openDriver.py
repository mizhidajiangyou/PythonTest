from selenium import webdriver

def openWebdriverMax():
	dr = webdriver.Chrome(r'../Tools/Webdriver/chromedriver.exe')
	# 最大化
	dr.maximize_window()
	# 隐性等待10S
	dr.implicitly_wait(10)
	return dr


if __name__=='__main__':

	dr = openWebdriverMax()
	dr.get("https://www.baidu.com/")
	dr.close()


