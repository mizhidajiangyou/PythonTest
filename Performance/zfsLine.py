from Common.fileOperate import readFileAndMakeList

path = "../OutPut/zpoolReport/zpool0.8..6/p_data/"
poolList = ["raid0", "raid10", "raid5", "raid6", "raid50", "raid60"]
poolFileNameList = []
pathList = []
dataList = []
xList = []
yList = []
for i in range(0, len(poolList)):
	poolFileName = "pool_" + poolList[i]
	poolFileNameList.append(poolFileName)
	# 池数据存放位置
	pathList.append(path + poolFileNameList[i] + "/")

	# 获取池数据
	dataList.append(readFileAndMakeList(pathList[i] + "pool"))
	# 定义横纵坐标存放

	dataListLen = len(dataList[i]/2)
	for j in range(0, int(dataListLen)):
		yList.append(dataList[i][2 * j])
		xList.append(dataList[i][2 * j + 1])
