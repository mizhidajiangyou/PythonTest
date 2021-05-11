'''
测试用例：
	用户登录
'''
from Common.createRandom import createRandomEmail


# 用户登录

def test_login():
	createRandomEmail()
	assert createRandomEmail() != True
