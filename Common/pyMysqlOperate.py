import pymysql

from Config.mysqlConfig import rootCon


def commitSql(sql, avgs, db, cursor):
	try:
		cursor.execute(sql, avgs)
		db.commit()
	except:
		db.rollback()


config = {'host': 'localhost',
		  'port': 3306,
		  'user': 'root',
		  'passwd': 'password',
		  'charset': 'utf8'
		  # 'db' : '数据库名'
		  }

conn = pymysql.connect(**config)
cursor = conn.cursor()
sql = "CREATE DATABASE IF NOT EXISTS db_name"
cursor.execute(sql)

print(cursor)

cursor.close()
conn.close()

config['db'] = 'db_name'

db = pymysql.connect(**config)

# cursor=pymysql.cursors.DictCursor 设置返回值为字典
cursor = db.cursor(cursor=pymysql.cursors.DictCursor)
# cursor = db.cursor()

sql = 'CREATE TABLE IF NOT EXISTS z_performance_date1(z_id INT UNSIGNED AUTO_INCREMENT,remarks VARCHAR(100),enter_date DATE,PRIMARY KEY ( z_id ))ENGINE=InnoDB DEFAULT CHARSET=utf8;'
cursor.execute(sql)

for i in range(0, 100):
	sql = "insert into z_performance_date1 (enter_date,remarks) values (%s,%s)"
	avgs = ('2022-05-19 11:35:02', i)
	commitSql(sql, avgs, db, cursor)
	# cursor.execute(sql,('2022-05-19 11:35:02',i))

	db.commit()

sql = "SELECT count(*) from z_performance_date1"
cursor.execute(sql)
print(cursor.fetchone()['count(*)'])
print(type(cursor.fetchone()))
# print(cursor.fetchall())
# print(cursor.fetchone())

cursor.close()
db.close()



