import pymysql, time
from Common.zDecorator import tryer, timer
from Config.currency import currencyLog

_zMySqlLog = currencyLog
# 默认配置参数
default_prefix = "z_mysql_performance_"
default_db_name = "default_db"
default_table_name = "default_table"
default_db_sql = "CREATE DATABASE IF NOT EXISTS "
default_table_sql = "CREATE TABLE IF NOT EXISTS "
default_table_value = "(z_id INT UNSIGNED AUTO_INCREMENT,remarks VARCHAR(100),enter_date DATE,PRIMARY KEY ( z_id ))ENGINE=InnoDB DEFAULT CHARSET=utf8;"
default_table_insert = "insert into {} (enter_date,remarks) values (%s,%s)"
default_table_delete = ""
default_table_update = ""
default_table_select = ""

config = {'host': 'localhost',
		  'port': 3306,
		  'user': 'root',
		  'passwd': 'P@ssw0rd',
		  'charset': 'utf8'
		  # 'db' : '数据库名'
		  }


# 库类
class zMySqlDataBase():

	def __init__(self, user_config: dict, table_num: int = 1, db_name: str = None, *args, **kwargs):
		# 日志
		self.log = _zMySqlLog
		# 数据库名称
		if db_name:
			self.db_name = db_name
		else:
			self.db_name = default_db_name
		# 数据库前缀
		if 'prefix' in kwargs:
			self.prefix = kwargs["prefix"]
		else:
			self.prefix = default_prefix
		# 查询数据库，不存在则创建
		self.db_sql = default_db_sql + self.prefix + self.db_name
		try:
			self.config = user_config
			self.conn = pymysql.connect(**self.config)
			self.cursor = self.conn.cursor()
			self.cursor.execute(self.db_sql)
			self.log.logger.info("cursor in mysql")
		except:
			self.log.logger.critical("connect mysql error!")
			exit(1)

	@tryer()
	def __del__(self):
		self.log.logger.info("close mysql connect !")
		self.cursor.close()
		self.conn.close()

	# 使游标进入库中，并另游标返回字典
	@tryer()
	def connect_db(self):
		self.cursor.close()
		self.conn.close()
		self.config['db'] = self.prefix + self.db_name
		self.conn = pymysql.connect(**self.config)
		self.cursor = self.conn.cursor(cursor=pymysql.cursors.DictCursor)
		self.log.logger.info("cursor in database:" + self.prefix + self.db_name)

	# 调用该函数,使游标进入数据库中，当没有指定名称时，进入default
	@tryer()
	def connect_new_db(self, new_db):
		if 'db' in self.config:
			del self.config['db']
		self.db_name = new_db
		self.db_sql = default_db_sql + self.prefix + self.db_name
		self.config = self.config
		self.conn = pymysql.connect(**self.config)
		self.cursor = self.conn.cursor()
		self.cursor.execute(self.db_sql)
		self.log.logger.info("move cursor in new database")
		self.connect_db()

	@timer(level="DEBUG")
	def commit_change(self):
		try:
			self.conn.commit()
		except:
			self.conn.rollback()


# 表类,根据游标进行表操作
class zMySqlTable():
	def __init__(self, cursor: classmethod, table_name: str = None, *args, **kwargs):
		# 日志
		self._log = _zMySqlLog
		# 表名
		if table_name:
			self.table_name = table_name
		else:
			self.table_name = default_table_name
		# 不建议修改的变量
		if 'prefix' in kwargs:
			self.table_prefix = kwargs["prefix"]
		elif 'table_sql' in kwargs:
			self.table_prefix = kwargs["table_sql"]
		elif 'table_value' in kwargs:
			self.table_prefix = kwargs["table_value"]
		elif 'insert' in kwargs:
			self.table_prefix = kwargs["insert"]
		elif 'delete' in kwargs:
			self.table_prefix = kwargs["delete"]
		elif 'update' in kwargs:
			self.table_prefix = kwargs["update"]
		elif 'select' in kwargs:
			self.table_prefix = kwargs["selec"]
		else:
			self.table_prefix = default_prefix
			self.table_sql = default_table_sql
			self.table_value = default_table_value
			self.table_insert = default_table_insert.format(self.table_prefix + self.table_name)
			self.table_delete = default_table_delete.format(self.table_prefix + self.table_name)
			self.table_update = default_table_update.format(self.table_prefix + self.table_name)
			self.table_select = default_table_select.format(self.table_prefix + self.table_name)

		# 检查表是否存在sql语句，不存在则创建
		self.check_sql = self.table_sql + self.table_prefix + self.table_name + self.table_value

		# 定义游标
		self.cursor = cursor

		try:
			self.cursor.execute(self.check_sql)
		except:
			self._log.logger.error("check table error!")
			exit(1)

	@timer(level="DEBUG")
	def do_insert(self, avgs: tuple):
		self.cursor.execute(self.table_insert, avgs)

	@timer(level="DEBUG")
	def do_insert_many(self, avgs: tuple):
		self.cursor.executemany(self.table_insert, avgs)

	def do_delete(self):
		pass

	def do_update(self):
		pass

	def do_select(self):
		pass


if __name__ == "__main__":
	z1 = zMySqlDataBase(config)

	z1.connect_new_db("db1")

	t1 = zMySqlTable(cursor=z1.cursor)

	for i in range(0, 100):
		t1.do_insert_many((('2022-05-19 11:35:02', i),('2022-05-20 11:35:02', i)))
	z1.commit_change()

	del z1
# print(z1.db_name)
