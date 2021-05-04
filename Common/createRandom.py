import  datetime
import json
import random
import string

def createRandomString(length):
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
	RandomString = ''.join([i for i in slcChar])
	return  RandomString

def createRandomEmail():
	return createRandomString(random.randint(1, 32)) + "@" + createRandomString(random.randint(1, 4)) + "." + createRandomString(random.randint(1, 4))

if __name__=='__main__':

	print(createRandomString(32))
	print(createRandomEmail())