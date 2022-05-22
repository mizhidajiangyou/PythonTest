import threading, time, queue
from Config.currency import currencyLog




if __name__ == '__main__':
	def aa(a,b,c):

		print("kkkkkkkkkkkkkk")
		print(a)
		print(b)
		print(c)


	a1=threading.Thread(target=aa, args=(1, 2, 3))

	a2=threading.Thread(target=aa, args=(33, 44, 550))

	a2.start()
	a1.start()