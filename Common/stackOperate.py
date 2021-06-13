class Stack(object):

	def __init__(self):
		# 创建空列表实现栈
		self.__stack = []

	def is_empty(self):
		# 判断是否为空
		return self.__stack == []

	def push(self, item):
		# 压栈，添加元素
		self.__stack.append(item)

	def pop(self):
		# 弹栈，弹出最后压入栈的元素
		if self.is_empty():
			return
		else:
			return self.__stack.pop()

	def top(self):
		# 获取栈顶元素（不出栈）
		if self.is_empty():
			raise IndexError
		else:
			return self.__stack[-1]

	def length(self):
		# 返回栈的大小
		return len(self.__stack)

class maxStack(object):

	def __init__(self):
		self.__stack = []
		self.__max = []

	def push(self, item):
		# 入栈
		self.__stack.append(item)

		if len(self.__max) == 0:
			self.__max.append(0)
		else:
			if self.__stack[self.__max[-1]] < item:
				self.__max.append(len(self.__stack) - 1)
			else:
				pass

	def pop(self):
		# 出栈
		if len(self.__stack) - 1 == self.__max[-1]:
			self.__max.pop()
		else:
			pass

		return self.__stack.pop()

	def getMax(self):
		# 获取最大值，牺牲空间换时间，空间复杂度 < O（n），只存储最大值下标
		if len(self.__max) == 0:
			raise IndexError
		else:
			return self.__stack[self.__max[-1]]

	def is_empty(self):
		# 判断是否为空
		return self.__stack == []

	def top(self):
		# 获取栈顶元素（不出栈）
		if self.is_empty():
			raise IndexError
		else:
			return self.__stack[-1]

	def length(self):
		# 返回栈的大小
		return len(self.__stack)

class minStack(object):

	def __init__(self):
		self.__stack = []
		self.__min = []  # 最小值下标

	def push(self, item):
		# 入栈
		self.__stack.append(item)

		if len(self.__min) == 0:
			self.__min.append(0)
		else:
			if self.__stack[self.__min[-1]] > item:
				self.__min.append(len(self.__stack) - 1)
			else:
				pass

	def pop(self):
		# 出栈
		if len(self.__stack) - 1 == self.__min[-1]:
			self.__min.pop()
		else:
			pass

		return self.__stack.pop()

	def getMin(self):
		# 获取最大值，牺牲空间换时间，空间复杂度 < O（n），只存储最小值下标
		if len(self.__min) == 0:
			raise IndexError
		else:
			return self.__stack[self.__min[-1]]

	def show_all(self):
		l = self.length()
		for i in range(0, l):
			print(self.__stack[i])
		return True

	def is_empty(self):
		# 判断是否为空
		return self.__stack == []

	def top(self):
		# 获取栈顶元素（不出栈）
		if self.is_empty():
			raise IndexError
		else:
			return self.__stack[-1]

	def length(self):
		# 返回栈的大小
		return len(self.__stack)


if __name__ == '__main__':
	s = Stack()
	max = maxStack()
	min = minStack()
	max.push(1)
	max.push(2)
	max.push(3)
	max.push(6)
	max.pop()
	print(max.getMax())
	min.push(9)
	min.push(3)
	min.push(-6)
	min.push(1)
	min.push(-4)
	min.pop()
	print(min.getMin())
	print(min.length())

	pass
