# 装饰器，显得高级
import time, wrapt
from Config.currency import currencyLog
from Common.timeOperate import returnYearMounthDay

decoratorLog = currencyLog


def timer(**kwargs):
	if 'level' in kwargs:
		level = kwargs["level"]
	else:
		level = ""
	if 'path' in kwargs:
		decoratorLog.zsave = kwargs['path']
	else:
		decoratorLog.zsave = '../Report/MyLogs/' + returnYearMounthDay() + '.save'

	@wrapt.decorator
	def wrapper(wrapped, instance, args, kwargs):
		start_time = time.time()
		wrapped(*args, **kwargs)
		end_time = time.time()
		d_time = end_time - start_time
		message = "do func {}() runing time is {}".format(wrapped.__name__, d_time)
		if level == "DEBUG":
			decoratorLog.logger.debug(message)
		elif level == "INFO":
			decoratorLog.logger.info(message)
		elif level == "WARING":
			decoratorLog.logger.warning(message)
		elif level == "ERROR":
			decoratorLog.logger.error(message)
		elif level == "CRITICAL":
			decoratorLog.logger.critical(message)
		elif level == "SAVE":

			decoratorLog.saveData()
			decoratorLog.logger.info(d_time)
		else:
			decoratorLog.logger.info(message)

	return wrapper


@timer()
def do(work):
	time.sleep(1)
	print(work)


if __name__ == "__main__":
	do("ccccccc")
