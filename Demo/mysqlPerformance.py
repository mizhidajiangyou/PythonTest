import os
import time
from Config import config
from Config import logger
from multiprocessing import Pool
from Common.timeOperate import returnAlldate
from Common.createRandom import createRandomString
from Common.pyMySqlOperate import zMySqlTable, zMySqlDataBase

from configparser import ConfigParser

# 获取配置文件和日志
_config = config.get_config()
_logger = logger.get_logger()

# 获取数据库相关配置
db_config = {'host': _config.get("mysql", "host", "localhost"), 'port': _config.getint("mysql", "port", 3306),
			 'user': _config.get("mysql", "user", "root"), 'passwd': _config.get("mysql", "passwd", "P@ssw0rd"),
			 'charset': _config.get("mysql", "charset", "utf-8")}
db_num = _config.getint("mysql", "db_num", 1000)
table_num = _config.getint("mysql", "table_num", 10000)
data_num = _config.getint("mysql", "data_num", 100000)

# 进程相关配置
pool_num = _config.getint("process", "pool_num", 16)
# 性能相关配置
db_performance_num = _config.getint("performance", "db_performance_num", 128)


def do_mysql_test(db: str):
	global _config, _logger, db_config, db_num, table_num, data_num
	# _logger.debug("PID: " + str(os.getpgid()))
	z_db = zMySqlDataBase(db_config)

	for num in range(db_num):
		# 连接数据库
		z_db.connect_new_db(db + str(num))
		# 创建表
		z_table = zMySqlTable(cursor=z_db.cursor)

		_logger.info("db: " + db + str(num) + " insert table: " + str(table_num))
		for i in range(table_num):
			z_table.table_name = "table" + str(i)
			z_table.check_table()
			# 表名称
			tn = z_table.table_prefix + z_table.table_name
			z_table.table_insert = "insert into{}(enter_date,remarks)values(%s,%s)".format(tn)
			for j in range(data_num):
				start_time = time.time()
				z_table.do_insert((returnAlldate(), str(j)))
				z_db.commit_change()
				end_time = time.time()
				all_time = end_time - start_time
				_logger.info(
					"db: " + db + str(
						num) + " table: " + z_table.table_prefix + z_table.table_name + " insert num:" + str(
						j) + " all use time: " + str(all_time))
			# 校验数据
			z_table.table_select = "select count(*) from {}".format(tn)
			z_table.do_select()
			z_table.show_one()
			if str(z_table.one["count(*)"]) == str(data_num):
				_logger.info("check count " + str(data_num) + " ok!")
			else:
				_logger.error("error! db: " + db + str(
					num) + " table: " + z_table.table_prefix + z_table.table_name + "all  insert num:" + str(
					data_num) + "but now :" + str(z_table.one["count(*)"]))
	del z_db


if __name__ == '__main__':
	pool = Pool(pool_num)
	for i in range(db_performance_num):
		db_name = createRandomString(16)
		pool.apply_async(do_mysql_test, args=tuple(db_name.split(",")))

	pool.close()
	pool.join()
