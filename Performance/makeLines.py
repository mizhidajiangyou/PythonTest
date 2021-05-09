# encoding=utf-8
import matplotlib.pyplot as plt
import datetime
from Common.fileOperate import readFileAndMakeList
import numpy as np


# 定义path（后续优化）
path = ["../Report/DiskPerformance/Outputs/HFA-FC-test1.txt","../Report/DiskPerformance/Outputs/HFA-iSCSI-test1.txt"]
pathname = ["HFA-FC","HFA-iSCSI"]
style=['r','o','blue','lime','*','peru']
# 获取数据
list = []
for i in range(0, len(path)):
	list.append(readFileAndMakeList(path[i]))
# print(list)

# x轴
x = ['随机写', '随机读', '写', '读']
# 定义数值
num = [[],[],[],[],[],[],[],[],[],[],[],[],[],[]]
# num = [[]*len(path)*2]
for i in range(0, len(list)):
	for j in range(0, len(x)):
		num[i].append( float(list[i][1][j]))
		num[i+len(list)].append(float(list[i][3][j]))
#print(num)

# 定义字体
plt.rc('font', family='SimHei', size=12)

# 设置画布大小
# plt.figure(figsize=(16, 4))

def pltset(index):
	# 数据
	for i in range(0, len(path)):
		print(num[i+index])
		plt.plot(x, num[i+index], label=pathname[i], linewidth=3, color=style[i*3], marker=style[i*3+1], markerfacecolor=style[i*3+2], markersize=6)
		for a, b in zip(x, num[i+index]):
			plt.text(a, b, b, ha='center', va='bottom', fontsize=10)
	plt.legend()
	plt.show()



i = 0
while i < 2:
	if i == 0:
		# 标题
		plt.title("BW")
		# # 横坐标描述
		# plt.xlabel('读写方式')
		# 纵坐标描述
		plt.ylabel('MB/s')
		pltset(0)
		chart = "linepng" + "-BW-" + datetime.datetime.now().strftime("%Y-%m-%d") + ".png"
		# 生成PNG
		plt.savefig('../Report/DiskPerformance/Charts/' + chart)
	else:
		plt.title("IOPS")
		# 纵坐标描述
		plt.ylabel('IOPS')
		pltset(1)
		chart = "linepng" + "-IOPS-" + datetime.datetime.now().strftime("%Y-%m-%d") + ".png"
		# 生成PNG
		plt.savefig('../Report/DiskPerformance/Charts/' + chart)
	i += 1
	# print(i)







