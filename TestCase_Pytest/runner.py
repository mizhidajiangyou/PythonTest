import  pytest
import os
import allure

class Test_runner():
	if __name__ == '__main__':
		# 生成测试报告json
		pytest.main(['-s', '-q', '../TestCase_Pytest', '--alluredir', '../Report/Allure/results'])
		# 将测试报告转为html格式
		os.system(r'allure generate --clean ../Report/Allure/results -o ../Report/Allure/reports')