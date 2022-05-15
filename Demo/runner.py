import pytest, os, datetime
from Common.timeOperate import returnYearMounthDay

if __name__ == '__main__':

	pwd = os.getcwd()
	father_path = os.path.dirname(pwd)
	now_date = returnYearMounthDay()
	out_file = father_path + '/Report/Allure/' + now_date + '/'
	if os.path.exists(out_file) == False:
		os.makedirs(out_file)

	# 生成json
	pytest.main(['-s', '-q', '../TestCase_Pytest', '--alluredir', out_file + 'results'])
	# 转换为html
	os.system(r'allure generate --clean ' + out_file + 'results/ -o ' + out_file + 'reports')
