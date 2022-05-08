'''
	用于发送登录请求
'''

from json import dumps
from Common.timeOperate import returnAlldate
from Config.currency import currencyLog, currencySession


class loginMysite():

	def __init__(self, host):
		self.host = host
		self.session = currencySession
		self.log = currencyLog
		self.logTime = 0

	def login(self, user, password):
		try:
			url = "http://" + self.host + "********"
			data = {
				"username": user,
				"password": password
			}
			respone = self.session.post(url, data=data)
			back = respone.json()
			if back["success"] == True and back["httpcode"] == 200:
				self.log.logger.info("login successful")
				self.log_time = returnAlldate()
				return True
			else:
				self.log.logger.error("login failed! http return :" + dumps(back))
				return False
		except:
			self.log.logger.critical("login error!")
			return False


if __name__ == '__main__':

	lin=loginMysite("www.baidu.com")
	lin.login("aaa","bbb")
