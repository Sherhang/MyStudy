import numpy as np
import matplotlib.pyplot as plt
from matplotlib.ticker import MultipleLocator, FormatStrFormatter

plt.rcParams['font.sans-serif']=['SimHei']   # 中文
plt.rcParams['axes.unicode_minus'] = False   # 负号
'''坐标轴设置'''
fig, ax = plt.subplots()
plt.axis([-1, 10, -2, 12])  # 坐标轴范围
#plt.axis('off')  # 不显示坐标轴
ax.xaxis.set_major_locator(MultipleLocator(1.5))  # x刻度为1.5的倍数
ax.xaxis.set_major_formatter(FormatStrFormatter('%1.2f'))  # x刻度显示格式
ax.yaxis.set_major_locator(MultipleLocator(2.5))  # y刻度为2.5的倍数
plt.xlabel(r'$\theta$/rad', fontsize=15, color='black')  # r''，$\ $用于转义
plt.ylabel(r'f($\theta$)',  fontsize=15, color='black', rotation='horizontal')  # rotation水平显示ylabel
'''画线条图'''
x = np.linspace(0, 10, 50)
y = np.sin(x)
line1, = ax.plot(x, y,                                                        # 加，可以在后面继续用其它语句设置
                 color='r', linestyle='-', dashes=[5, 0, 5, 0], linewidth=2,  # 设置线条样式
                 marker='o', markersize='8', markeredgecolor='g', markeredgewidth=2,  # 设置标注样式，就是点的位置的标注
                 label='正弦图像')   # 设置标签名称
line2, = ax.plot(x, np.cos(x), dashes=[30, 5, 10, 5], label='余弦图像')
x, y = np.random.rand(2, 100)*10
ax.scatter(x, y, c='b', s=np.random.rand(100)*100, label='points',
           alpha=0.3,  edgecolors='g')
ax.legend(loc='upper right')  # label 的位置
plt.savefig(fname='out\mytest.png', dpi=720)  # 存储位置，分辨率
plt.show()
