# 该文件需要放在二级目录下
# coding=utf-8
from Common.timeOperate import returnYearMounthDayFile
from Config.currency import PERFORMANCEPATH, currencylog, TESTPATH
from Common.fileOperate import makeHtmlRport,readFileAndMakeString
import os

makeLog = currencylog

if __name__ == "__main__":
	orPath = PERFORMANCEPATH
	html = readFileAndMakeString("DiskPerformanceReport/indexDemo.html")
	js = readFileAndMakeString("DiskPerformanceReport/mainDemo.js")
	css = readFileAndMakeString("DiskPerformanceReport/globalDemo.css")
	makeHtmlRport(orPath,html,js,css)

