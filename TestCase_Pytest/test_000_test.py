from Common.createRandom import createRandomEmail


def test_login():
	createRandomEmail()
	assert createRandomEmail() == True
