# encoding=utf-8
import matplotlib.pyplot as plt
import datetime
from Common.fileOperate import readFileAndMakeList
from Common.createRandom import createLineStyle
import numpy as np


class zChart:
	"""

	"""

	def __init__(self, oPath, pathName, xAxis, yAxis, title, sPath):
		self.oPath = oPath
		self.pathName = pathName
		self.xAxis = xAxis
		self.yAxis = yAxis
		self.title = title
		self.plt = plt
		self.dataList = []
		self.pltData = [[], [], [], [], [], [], [], [], [], [], [], [], [], []]
		self.sPath = sPath
		# 定义字体
		self.plt.rc('font', family='SimHei', size=12)

	def makeFrame(self):
		self.plt.title(self.title)
		self.plt.ylabel = self.yAxis
		self.plt.xlabel = self.xAxis

	def getLineData(self):
		# 获取数据
		self.dataList = []
		for i in range(0, len(self.oPath)):
			self.dataList.append(readFileAndMakeList(self.oPath[i]))
		# print(self.dataList)
		# 获取x轴制图数据
		for i in range(0, len(self.dataList)):
			for j in range(0, len(x)):
				self.pltData[i].append(float(self.dataList[i][1][j]))
				self.pltData[i + len(self.dataList)].append(float(self.dataList[i][3][j]))

	def getIostatData(self):
		# 获取数据
		self.dataList = []
		__fileData = readFileAndMakeList(self.oPath)
		for i in range(0, len(__fileData)):
			self.dataList.append(float(__fileData[i][0]))

	def pltIostatLineSet(self):
		self.getIostatData()
		# x轴
		x  = range(0, len(self.dataList))
		# self.plt.grid(True)
		self.plt.title(self.title)

		self.plt.xlabel = x
		self.plt.plot(x, self.dataList, label=self.pathName, linewidth=3, color='b')
		self.plt.ylabel = self.yAxis


	def pltLineSet(self, index):
		# index ：1 为BW的数据 2为 IOPS 待处理		
		# 线的风格
		style = createLineStyle(len(self.oPath))
		# 数据
		for i in range(0, len(self.oPath)):
			# print(i+index*len(self.oPath))
			# print(num[i+index*len(self.oPath)])
			self.plt.plot(self.xAxis, self.pltData[i + index * len(self.oPath)], label=self.pathName[i], linewidth=3,
						  color=style[i * 3],
						  marker=style[i * 3 + 1], markerfacecolor=style[i * 3 + 2], markersize=6)
			for a, b in zip(self.xAxis, self.pltData[i + index * len(self.oPath)]):
				self.plt.text(a, b, b, ha='center', va='bottom', fontsize=10)
			self.plt.legend(loc='upper right', frameon=False)

	def makeLine(self, index):
		# 清除轴开始绘图
		self.plt.clf()
		self.makeFrame()
		self.pltLineSet(index)
		save = self.sPath + self.title + ".png"
		plt.savefig(save)

	def makeIostatLine(self):
		# 清除轴开始绘图
		self.plt.clf()

		self.pltIostatLineSet()
		save = self.sPath + self.title + ".png"
		plt.savefig(save)


if __name__ == "__main__":
	#x = ['随机写', '随机读', '写', '读']
	x="aa"
	t1 = "BW"
	t2 = "IOPS"
	t3= "DISK_BW"
	t4 = "DISK_IOPS"
	t5= "disk-write"
	op= ["../Report/DiskPerformance/2021-05-26/HFA-FC-test1.txt","../Report/DiskPerformance/2021-05-26/HFA-iSCSI-test1.txt","../Report/DiskPerformance/2021-05-26/Test-NFS-max-test.txt"]
	op2="../Report/DiskPerformance/2021-05-26/libaio-4k-write.iostat.write"
	on = ["FC","SCSI","NFS"]
	on2 = "disk-sde"
	y1= "MB/S"
	y2 = "IOPS"
	sp="../Report/DiskPerformance/2021-05-26/"

	lii = zChart(op2,on2,x,y1,t5,sp)
	# lii.getLineData()
	# lii.makeLine(0)
	# lii.yAxis=y2
	# lii.title=t2
	# lii.makeLine(1)
	lii.makeIostatLine()
