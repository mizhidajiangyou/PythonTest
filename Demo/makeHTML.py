# 该文件需要放在二级目录下
# coding=utf-8
from Common.timeOperate import returnYearMounthDayFile
from Config.currency import retryCount, currencylog
from Common.fileOperate import readFileAndMakeString
import os

makeLog = currencylog


def makeReport(orPath,html,js,css):
	# 定义存放报告路径
	# orPath = "../Report/DiskPerformance/Report/"
	# 在存放路径下生成日期文件，将存放html、js、css等文件
	rePath = returnYearMounthDayFile(orPath)
	# 判断是否成功
	if rePath != False:
		makeLog.logger.info("make file successful!")
	else:
		makeLog.logger.error("make file error!")

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
	makeReport()
