import datetime
import json
import random
import string


def createRandomString(length):
	"""
	:Usage: 生成随机字符串
	:param length: int 生成字符串长度
	:return: 随机字符串
	"""
	# 生成随机数字个数
	num = random.randint(1, length)
	# 定义字母个数
	letterNum = length - num
	'''
	string.digits：数字0~9

	string.ascii_letters：所有字母（大小写）

	string.lowercase：所有小写字母

	string.printable：可打印字符的字符串

	string.punctuation：所有标点

	string.uppercase：所有大写字母
	'''
	# 定义0-9
	number = string.digits
	# 定义a-z
	# letter = [chr(i) for i in range(97, 123)]
	letter = string.ascii_lowercase
	# 从number中选中num个字母
	slcNumber = [random.choice(number) for i in range(num)]
	# 从letter中选中letterNum个字母
	slcLetter = [random.choice(letter) for i in range(letterNum)]
	# 打乱顺序
	slcChar = slcLetter + slcNumber
	random.shuffle(slcChar)
	# 格式化输出
	randomString = ''.join([i for i in slcChar])
	return randomString


def createRandomEmail():
	"""
	:Usage: 生成随机邮箱
	:return:
	"""
	return createRandomString(random.randint(1, 32)) + "@" + createRandomString(
		random.randint(1, 4)) + "." + createRandomString(random.randint(1, 4))


def createLineStyle(length):
	"""
		生成用于制作折线图的颜色
	:param length:
	:return:
	"""
	style = []
	# 线的颜色
	color = ["#20f986", "#75bbfd", "#ef1de7",  "#FF0000", "#00FFFF", "#FFF8DC", "#B8860B", "#A9A9A9",
			 "#696969", "#FF00FF", "#808080", "#FFFACD", "#D3D3D3", "#66CDAA", "#191970", "#6B8E23", "#AFEEEE",
			 "#CD853F","#FFC0CB","#BC8F8F","#2E8B57","#FFFAFA","#008080","#40E0D0","#9ACD32"]
	# 转折点颜色
	markerfacecolor = ["#0000CD","#BA55D3","#9370DB","#800000", "#66CDAA",  "#FF0000", "#00FFFF", "#FFF8DC", "#B8860B", "#A9A9A9",
			 "#696969", "#FF00FF", "#808080", "#FFFACD", "#D3D3D3", "#66CDAA", "#191970", "#6B8E23", "#AFEEEE",
			 "#CD853F","#FFC0CB","#BC8F8F","#2E8B57","#FFFAFA","#008080","#40E0D0","#9ACD32"]
	# 转折点
	marker = [".",",","o","v","1","2","*","X","x","d","D","|","h","H","+",">","<","^","p","P","s"]
	styleColor=[random.choice(color) for i in range(length)]
	styleMarkerFaceColor=[random.choice(markerfacecolor) for i in range(length)]
	styleMarker=[random.choice(marker) for i in range(length)]

	# 生成style
	for i in range(0,length):
		style.append(styleColor[i])
		style.append(styleMarker[i])
		style.append(styleMarkerFaceColor[i])

	return style


if __name__ == '__main__':
	#print(createRandomString(32))
	#print(createRandomEmail())
	print(createLineStyle(3))
