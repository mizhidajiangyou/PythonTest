import pytest
import os

class Test_runner():
	if __name__ == '__main__':
		# 生成json
		pytest.main(['-s', '-q', '../TestCase_Pytest', '--alluredir', '../Report/Allure/results'])

		# 转换为html
		os.system(r'allure generate --clean ../Report/Allure/results -o ../Report/Allure/reports')