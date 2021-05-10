from locust import  HttpUser,TaskSet,task, between



class userBehavior(TaskSet):
	@task
	def test_index(self):
		# 新版本self.client = session
		response=self.client.get("/")
		#response.encoding= 'gbk'

class webSiteUser(HttpUser):
	host = "http://www.baidu,com"
	# 1.0版本以后为tasks=数组/字典
	tasks = [userBehavior]
	# min_wait=2000
	# max_wait= 5000
	between(1,10)