# encoding=utf-8
import matplotlib.pyplot as plt

plt.rc('font', family='SimHei', size=12)
# x轴
x1 = ['写', '读', '随机写', '随机读']

# 数值
y1 = [1605.4, 5406.2, 781.9, 2544.7]
y2 = [1542.3, 5191.1, 757.5, 2705.4]
y3 = [1640.8, 4809.5, 787.6, 2736.5]

# 设置画布大小
# plt.figure(figsize=(16, 4))

# 标题
plt.title("1M读写")

# 数据
plt.plot(x1, y1, label='ashift=0', linewidth=3, color='r', marker='o',
		 markerfacecolor='blue', markersize=6)
plt.plot(x1, y2, label='ashift=9', linewidth=3, color='lime', marker='*',
		 markerfacecolor='peru', markersize=10)
plt.plot(x1, y3, label='ashift=12', linewidth=3, color='mediumpurple', marker='X',
		 markerfacecolor='lightyellow', markersize=10)

# 横坐标描述
plt.xlabel('读写方式')

# 纵坐标描述
plt.ylabel('MB/s')

# 设置数字标签
for a, b in zip(x1, y1):
	plt.text(a, b, b, ha='center', va='bottom', fontsize=10)
# 设置数字标签
for a, b in zip(x1, y2):
	plt.text(a, b, b, ha='center', va='bottom', fontsize=10)
# 设置数字标签
for a, b in zip(x1, y3):
	plt.text(a, b, b, ha='center', va='bottom', fontsize=10)

plt.legend()
plt.show()
