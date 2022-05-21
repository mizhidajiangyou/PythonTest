import logging
import datetime
from os import getcwd, path, makedirs

pwd = getcwd()
father_path = path.dirname(pwd)
if path.exists(father_path + '/Report/MyLogs/') == False:
	makedirs(father_path + '/Report/MyLogs/')
# 日志等级
'''
	CRITICAL = 50
	FATAL = CRITICAL
	ERROR = 40
	WARNING = 30
	WARN = WARNING
	INFO = 20
	DEBUG = 10
	NOTSET = 0
'''
LEVEL = 10


class zLog:
	def __init__(self):
		global LEVEL
		self.level = LEVEL
		self.zsave = ""
		# 获取当前时间
		nowTime = datetime.datetime.now()
		# 实例化日志
		self.logger = logging.getLogger()
		# 初始化zTime(日志输出文档日期) 格式为xxxx-xx-xx
		self.zTime = nowTime.strftime("%Y-%m-%d")
		# 设置日志输出
		'''
		%(levelno)s: 打印日志级别的数值
		%(levelname)s: 打印日志级别名称
		%(pathname)s: 打印当前执行程序的路径，其实就是sys.argv[0]
		%(filename)s: 打印当前执行程序名
		%(funcName)s: 打印日志的当前函数
		%(lineno)d: 打印日志的当前行号
		%(asctime)s: 打印日志的时间
		%(thread)d: 打印线程ID
		%(threadName)s: 打印线程名称
		%(process)d: 打印进程ID
		%(message)s: 打印日志信息
		'''
		self.formatter = logging.Formatter('%(asctime)s - %(filename)s[line:%(lineno)d] - %(levelname)s: %(message)s')
		# self.formatter = logging.Formatter('%(asctime)s - %(name) - %(levelname)s - %(message)s')
		# 日志输出位置
		self.path = '../Report/MyLogs/' + self.zTime + '.log'
		# 日志等级
		self.logger.setLevel(self.level)
		'''
		StreamHandler: 
			能够将日志信息输出到sys.stdout, sys.stderr 或者类文件对象（更确切点，就是能够支持write()和flush()方法的对象）。
			参数：
				class logging.StreamHandler(stream=None)
			日志信息会输出到指定的stream中，如果stream为空则默认输出到sys.stderr。
		FileHandler:
			继承自StreamHandler。将日志信息输出到磁盘文件上。
			参数：
			class logging.FileHandler(filename, mode='a', encoding=None, delay=False)
			模式默认为append，delay为true时，文件直到emit方法被执行才会打开。默认情况下，日志文件可以无限增大。
		RotatingFileHandler:
			支持循环日志文件。
			参数:
			class logging.handlers.RotatingFileHandler(filename, mode='a', maxBytes=0, backupCount=0, encoding=None, delay=0)
			参数maxBytes和backupCount允许日志文件在达到maxBytes时rollover.当文件大小达到或者超过maxBytes时，就会新创建一个日志文件。上述的这两个参数任一一个为0时，rollover都不会发生。也就是就文件没有maxBytes限制。backupcount是备份数目，也就是最多能有多少个备份。命名会在日志的base_name后面加上.0-.n的后缀，如example.log.1,example.log.1,…,example.log.10。当前使用的日志文件为base_name.log。
		'''
		# 日志文件输出
		log1 = logging.FileHandler(self.path, mode='a')
		log1.setLevel(self.level)
		# 控制台输出
		log2 = logging.StreamHandler()
		log2.setLevel(self.level)
		# 输出格式设置
		log1.setFormatter(self.formatter)
		log2.setFormatter(self.formatter)
		'''
		简单排查python logging库，按以上方式使用存在以下现象：
		* 利用addHandler 往handlers数组中添加hdlr，再次实例化logging.getLogger()并不会清楚这个数组
		* 简单增加判断if len(logger.handlers) == 0 : 再进行addHandler操作
		'''
		# 将log1和2加入流中
		if len(self.logger.handlers) <= 0:
			self.logger.addHandler(log1)
		else:
			self.logger.handlers[0]=log1
		if len(self.logger.handlers) <= 1:
			self.logger.addHandler(log2)
		else:
			self.logger.handlers[1]=log2

	# self.logger.addHandler(log1)
	# self.logger.addHandler(log2)

	def saveData(self):
		# 保存位置
		if self.zsave == "":
			self.zsave = '../Report/MyLogs/' + self.zTime + '.save'
		log3 = logging.FileHandler(self.zsave, mode='a')
		log3.setLevel(self.level)
		print(len(self.logger.handlers))
		if len(self.logger.handlers) <= 2:
			self.logger.addHandler(log3)
		else:
			self.logger.handlers[2]=log3

	def delsave(self):
		del self.logger.handlers[2]

if __name__ == '__main__':
	log = zLog()
	log.logger.debug('debug test')
	log.logger.info('info test')
	log.logger.warning('warning test')
	log.logger.error('error test')
	log.logger.critical('critical test')
	log.saveData()
	log.logger.debug('debug test')
	log2 = zLog()
	log2.logger.debug('debug1 test')

	log3 = zLog()
	log3.logger.debug('debug2 test')
	log2.delsave()
