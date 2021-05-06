def judgeOS(function, bak):
	try:
		function
		print(bak + " successful!")
	except OSError:
		print("os error!")
	except IOError:
		print("io error!")
	except Exception:
		print("Exception!")


if __name__ == '__main__':

	def testa():
		print("aaaaa")
	judgeOS(testa(), "输出aaa")
