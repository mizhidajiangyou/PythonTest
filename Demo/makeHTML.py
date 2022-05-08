# 该文件需要放在二级目录下
# coding=utf-8
import json

from Common.timeOperate import returnYearMounthDayFile
from Config.currency import PERFORMANCEPATH, currencyLog, TESTPATH,TESTDATAPATH
from Config.regularExpression import jsRegularExpression
from Common.fileOperate import makeHtmlRport,readFileAndMakeString
from Common.reOperate import reSub

import os

makeLog = currencyLog

if __name__ == "__main__":
	orPath = PERFORMANCEPATH
	html = readFileAndMakeString("DiskPerformanceReport/indexDemo.html")
	js = readFileAndMakeString("DiskPerformanceReport/mainDemo.js")
	css = readFileAndMakeString("DiskPerformanceReport/globalDemo.css")
	# 读取jsData.json中的数据，并修改
	file = open(TESTDATAPATH + "jsData.json", "rb")
	jsDate = json.load(file)
	file.close()
	jsDate[0]["totalTableData"][0]["testdate"] = 7777777777777777
	jsSrtingDate = []
	# 转换json格式为str
	for i in range(0,len(jsDate)):
		jsSrtingDate.append(json.dumps(jsDate[i]))
	# print(jsSrtingDate)
	# 根据正则依次替换
	for i in range(0,len(jsSrtingDate)):
		js = reSub(jsRegularExpression[i], jsSrtingDate[i], js)
	# print(js)
	# reSub(totalTableData,)
	# makeHtmlRport(orPath,html,js,css)

