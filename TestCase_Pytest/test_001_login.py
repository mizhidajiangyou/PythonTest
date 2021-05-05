'''
测试用例：
	用户登录
'''

from Config.currency import *


# 用户登录

def test_login():
	createRandomEmail()
	assert createRandomEmail() != True
