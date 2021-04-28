import matplotlib.pyplot as plt
import numpy as np


def auto_label(rects):
    for rect in rects:
        height = rect.get_height()
        ax.annotate('{}'.format(height), # put the detail data
                    xy=(rect.get_x() + rect.get_width() / 2, height), # get the center location.
                    xytext=(0, 3),  # 3 points vertical offset
                    textcoords="offset points",
                    ha='center', va='bottom')


def auto_text(rects):
    for rect in rects:
        ax.text(rect.get_x(), rect.get_height(), rect.get_height(), ha='left', va='bottom')
#中文字体支持
#plt.rc('font', family='SimHei', size=12)
#x轴
labels = ['label0', 'label1', 'label2', 'label3']
#数据
num_list = ["mmm0", "mmm1", "mmm2", "mmm3"]

#换为float
for i in range(0,len(num_list)):

    if num_list[i][-1:] == "k":
        num_list[i]=float(num_list[i][:-1])*1000
    else:
        num_list[i]=float(num_list[i])

#for i in range(0,len(num_list)):
#    if num_list[i][-1:] == "k":
#        num_list[i]=float(num_list[i][:-1])*1000
 
        
#women_means = [25, 32, 34, 20, 25]

index = np.arange(len(labels))
width = 0.2

fig, ax = plt.subplots()
rect1 = ax.bar(range(len(num_list)), num_list, color ='#springgreen', width=width, label='BW')
#rect2 = ax.bar(index + width / 2, women_means, color ='springgreen', width=width, label ='Women')
#标题
ax.set_title('test-title')

ax.set_xticks(ticks=index)
ax.set_xticklabels(labels)
#y轴描述
ax.set_ylabel('miaoshu')

# ax.set_ylim(0, 50)
#柱状图数值显示
auto_label(rect1)
# auto_label(rect2)
# auto_text(rect1)
# auto_text(rect2)

ax.legend(loc='upper right', frameon=False)
fig.tight_layout()
#生成PNG
plt.savefig('barpng')
#plt.show()