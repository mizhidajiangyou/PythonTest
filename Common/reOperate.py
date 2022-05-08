import re
from Config.regularExpression import *
from Common.fileOperate import readFileAndMakeString
from Config.currency import currencyLog

reLog =currencyLog

def reSub(rExpression,rString, orString):
	"""
		将原始字符串中正则匹配部分替换
	:param rExpression: 正则规则
	:param rString: 替换的内容
	:param orString: 原始字符串
	:return: 成功返回替换成功后的字符串
	"""
	try:
		findString = re.search(rExpression, orString).group()
		fiString = re.sub(rExpression,rString,orString)
		reLog.logger.debug("已将字符串：" + orString + "中的" + findString + "替换为：" + rString)
		reLog.logger.info("替换字符串成功")
		return  fiString
	except:
		reLog.logger.error("替换字符串失败！")
		return False





if __name__ == "__main__":
	S = readFileAndMakeString("../Demo/DiskPerformanceReport/mainDemo.js")
	a = "bbbb"
	rp = "testttt: [{test:" + a +  "}],"
	reSub(testttt,rp ,S)
