import datetime


def returnAlldate():
	date = str(datetime.datetime.now().strftime("%Y-%m-%d-%H-%M-%S"))
	return date

def returnDayTime():
	date = str(datetime.datetime.now().strftime("%d-%H-%M-%S"))
	return date

