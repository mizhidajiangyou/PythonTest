def readFileAndMakeList(path):
	# 打开一个文件
	file = open(path, "r")
	# 定义一个数组
	list = []
	# 读取每一行的内容
	str = file.readlines()
	# 根据空格切割将读取到的内容生成一个二维数组
	for i in range(0, len(str)):
		list.append(str[i].strip().split())

	print("已生成数组 : ", list)
	# 关闭打开的文件
	file.close()
	return  list

if __name__ == "__main__":

	path = '../Report/DiskPerformance/HFA-FC-test1.txt'
	list = readFileAndMakeList(path)
