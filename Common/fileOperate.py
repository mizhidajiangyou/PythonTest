from Config.currency import currencylog,TESTPATH
from Common.timeOperate import returnYearMounthDayFile


# 实例化log模块
fileLog = currencylog

def readFileAndMakeList(path):
	try:
		# 打开一个文件
		file = open(path, "r")
		# 定义一个数组
		list = []
		# 读取每一行的内容
		str = file.readlines()
		# 根据空格切割将读取到的内容生成一个二维数组
		for i in range(0, len(str)):
			list.append(str[i].strip().split())

		fileLog.logger.info("已生成数组 : " +  list)
		# 关闭打开的文件
		file.close()
		return list
	except:
		return False


def readFileAndMakeString(path):
	try:
		# 打开一个文件
		file = open(path, "r")
		# 定义一个数组
		list = ""
		# 读取每一行的内容
		str = file.readlines()
		list = list.join(str)
		fileLog.logger.info("已生成字符串 : " + list)
		# 关闭打开的文件
		file.close()
		return list
	except:
		return False


def makeHtmlRport(orPath,html,js,css):
	# 在存放路径下生成日期文件，将存放html、js、css等文件
	rePath = returnYearMounthDayFile(orPath)
	# 判断是否成功
	if rePath != False:
		fileLog.logger.info("make file:" + rePath + " successful!")
	else:
		fileLog.logger.error("make file error!")

	# html、js、css等文件路径
	htmlPath = rePath + "/index.html"
	jsPath = rePath + "/main.js"
	cssPath = rePath + "/all.css"

	# 打开文件
	fileHTML = open(htmlPath, 'w', encoding='utf8')
	fileCSS = open(cssPath, 'w', encoding='utf8')
	fileJS = open(jsPath, 'w', encoding='utf8')

	# 写入数据
	fileHTML.write(html)
	fileJS.write(js)
	fileCSS.write(css)

	# 关闭文件
	fileHTML.close()
	fileCSS.close()
	fileJS.close()



if __name__ == "__main__":
	# path = '../Report/DiskPerformance/Outputs/HFA-FC-test1.txt'
	# list = readFileAndMakeList(path)

	orPath = TESTPATH + "\Report\DiskPerformance\Report\\"
	makeHtmlRport(orPath,"aa","bb","cc")
