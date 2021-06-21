from Config.currency import currencylog, TESTPATH, PERFORMANCEREPORT
from Common.timeOperate import returnYearMounthDayFile
import os
import shutil
import sys

# 实例化log模块
fileLog = currencylog


def readFileAndMakeList(path):
	"""
		根据文件内容，生成数组，每一行为数组中的一组数组元素
	:param path:
	:return:
	"""
	try:
		# 打开一个文件
		file = open(path, "r", encoding='utf-8')
		# 定义一个数组
		list = []
		# 读取每一行的内容
		str = file.readlines()
		# 根据空格切割将读取到的内容生成一个二维数组
		for i in range(0, len(str)):
			list.append(str[i].strip().split())

		fileLog.logger.info("成功生成数组！")
		fileLog.logger.debug(list)
		# 关闭打开的文件
		file.close()
		return list
	except FileNotFoundError:
		fileLog.logger.error("file not found!")
		return False
	except :
		return False


def readFileAndMakeString(path):
	try:
		# 打开一个文件
		file = open(path, "r", encoding='utf-8')
		# 定义一个数组
		list = ""
		# 读取每一行的内容
		str = file.readlines()
		list = list.join(str)
		fileLog.logger.debug("已生成字符串 : " + list)
		fileLog.logger.info("生成字符串成功！")
		# 关闭打开的文件
		file.close()
		return list
	except:
		fileLog.logger.error("转换文件： " + path + " 失败")
		return False


def makeHtmlRport(orPath, html, js, css):
	"""
		在orPath路径下生成当日日期文件并在该文件中生成html、css、js
	:param orPath: 可写相对路径../；绝对路径TESTPATH + "\XXX\XXX\\"
	:param html: HTML文件内容
	:param js: js文件内容
	:param css: css文件内容
	:return:
	"""
	# 在存放路径下生成日期文件，将存放html、js、css等文件
	rePath = returnYearMounthDayFile(orPath)
	# 判断是否成功
	if rePath != False:
		fileLog.logger.info("make file:" + rePath + " successful!")
	else:
		fileLog.logger.error("make file error!")

	# html、js、css等文件路径
	htmlPath = rePath + "/indexDemo.html"
	jsPath = rePath + "/mainDemo.js"
	cssPath = rePath + "/globalDemo.css"
	try:
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
		fileLog.logger.info("make html in :" + orPath + " successful!")
		return True
	except:
		fileLog.logger.error("make html in :" + orPath + " failed!")
		return False

def createDir(path):
    isExists=os.path.exists(path)
    # 判断结果
    if not isExists:
        # 如果不存在则创建目录
        os.makedirs(path)
        fileLog.logger.debug(path+' 目录创建成功')
    else:
        # 如果目录存在则不创建，并提示目录已存在
        fileLog.logger.debug(path+' 目录已存在')

def copyFile(filePath,newPath):
	try :
		# 获取当前路径下的文件名，返回List
		fileNames = os.listdir(filePath)
		for file in fileNames:
			# 将文件命加入到当前文件路径后面
			newDir = filePath +  file
			# 如果是文件
			if os.path.isfile(newDir):
				# print(newDir)
				newFile = newPath + file
				shutil.copyfile(newDir, newFile)
			# 如果不是文件，递归这个文件夹的路径
			else:
				copyFile(newDir, newPath)
		fileLog.logger.debug("复制" +filePath +"下的文件至"+newPath+"成功！" )
		fileLog.logger.info("复制成功！")
	except:
		fileLog.logger.error("error!")

def compareMD5(path):
	try:
		list=readFileAndMakeList(path)
		if len(list) == 2:
			if list[0] == list[1]:
				fileLog.logger.info("md5值一致!")
				fileLog.logger.debug("第一次的md5值为:"+ str(list[0]) +" 第二次的md5值为："+str(list[1]))
			else:
				fileLog.logger.error("md5值不一致")
				fileLog.logger.debug("第一次的md5值为:" + str(list[0]) + " 第二次的md5值为：" + str(list[1]))
		else:
			fileLog.logger.error("校验文件md5数据不正确！")
			fileLog.logger.info("文件内容为： ")
			fileLog.logger.info(list)

	except:
		fileLog.logger.error("compareERROR!")





if __name__ == "__main__":
	# path = '../Report/DiskPerformance/Outputs/HFA-FC-test1.txt'
	# list = readFileAndMakeList(path)

	# orPath = TESTPATH + "\Report\DiskPerformance\Report\\"
	# makeHtmlRport(orPath,"aa","bb","cc")

	# a = readFileAndMakeString("../Demo/DiskPerformanceReport/mainDemo.js")
	# print(a)

	# souPath = TESTPATH + "\Demo\DiskPerformanceReport\\"
	# desPath = PERFORMANCEREPORT
	# copyFile(souPath, desPath)

	path = TESTPATH +"\TestData\md5"
	compareMD5(path)