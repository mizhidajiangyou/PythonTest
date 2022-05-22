# 装饰器，显得高级
import time, wrapt
from Config.currency import currencyLog
from Common.timeOperate import returnYearMounthDay

_decoratorLog = currencyLog


def timer(*args, **kwargs):
	if 'level' in kwargs:
		level = kwargs["level"]
	else:
		level = ""
	if 'path' in kwargs:
		_decoratorLog.zsave = kwargs['path']
	else:
		_decoratorLog.zsave = '../Report/MyLogs/' + returnYearMounthDay() + '.save'

	@wrapt.decorator
	def wrapper(wrapped, instance, args, kwargs):
		start_time = time.time()
		wrapped(*args, **kwargs)
		end_time = time.time()
		d_time = end_time - start_time
		message = "do func {}() runing time is {}".format(wrapped.__name__, d_time)
		if level == "DEBUG":
			_decoratorLog.logger.debug(message)
		elif level == "INFO":
			_decoratorLog.logger.info(message)
		elif level == "WARING":
			_decoratorLog.logger.warning(message)
		elif level == "ERROR":
			_decoratorLog.logger.error(message)
		elif level == "CRITICAL":
			_decoratorLog.logger.critical(message)
		elif level == "SAVE":

			_decoratorLog.saveData()
			_decoratorLog.logger.info(d_time)
		else:
			_decoratorLog.logger.info(message)

	return wrapper


def tryer(*args, **kwargs):
	@wrapt.decorator
	def wrapper(wrapped, instance, args, kwargs):
		message = "do func {}() ".format(wrapped.__name__)
		try:
			wrapped(*args, **kwargs)
			_decoratorLog.logger.debug(message + "successful!")
		except OSError:
			_decoratorLog.logger.error(message + "os error!")
		except IOError:
			_decoratorLog.logger.error(message + "io error!")
		except FileNotFoundError:
			_decoratorLog.logger.error(message + "file not found!")
		except Exception:
			_decoratorLog.logger.error(message + "Exception!")

	return wrapper


if __name__ == "__main__":
	@timer()
	def do(work):
		time.sleep(1)
		print(work)


	do("ccccccc")


	@tryer()
	def aa():
		print("aa")


	aa()
