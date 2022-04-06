# encoding: utf-8
import os
import sys

parent_path = os.path.dirname(sys.path[0])
if parent_path not in sys.path:
	sys.path.append(parent_path)
from Common.makeCharts import zChart

if __name__ == "__main__":
	x = ["随机写", "随机读", "读", "写"]
	title = "LINE_TITLE" + ".bs"
	savePath = "SAVE_PATH"
	op = savePath + title
	on = "volume"
	y = "MB/S"

	IOLine = zChart(op, on, x, y, title, savePath)
	IOLine.makeIostatLine()
	title = "LINE_TITLE" + ".iops"
	IOLine.title = title
	IOLine.yAxis = "iops"
	IOLine.oPath = savePath + title
	IOLine.makeIostatLine()
