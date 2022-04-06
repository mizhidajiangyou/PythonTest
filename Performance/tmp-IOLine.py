# encoding: utf-8
import os
import sys

parent_path = os.path.dirname(sys.path[0])
if parent_path not in sys.path:
	sys.path.append(parent_path)
from Common.makeCharts import zChart

if __name__ == "__main__":
	x = ["随机写", "随机读", "读", "写"]
	title = "iolinetest"
	savePath = "D:\\pythontest\\autoTest\\Report\\DiskPerformance\\2021-05-26\\"
	op = savePath + title
	on = "volume"
	y = "MB/S"

	IOLine = zChart(op, on, x, y, title, savePath)
	IOLine.makeIostatLine()
