from sys import argv

import numpy as np
import pandas as pd
import time
import matplotlib.pyplot as plt

from TSPSOM import *

def main():


    # 参数
    steps = 10000   #  迭代次数
    dSteps = 100  # 每隔100次取一次步数

    Repeat = 2  # 每个算法平均执行次数
    Datas = ["att48", "chn144", "a280", "ali535", "rl1304"]
    comt = 5
    # 基本变量
    dSave = np.zeros((steps // dSteps, comt))  # 一共comt个需要比较的算法
    dMin = 999999999999 * np.ones(comt)  # 最好解
    dMax = np.zeros(comt)  # 最差解
    tSave = np.zeros(comt)  # 算法的执行时间
    convSave = np.zeros(comt)  # 收敛步数，定义为最后距离的1%以内

    for k in range(Repeat):
        for i in range(comt):
            data = "assets/"+Datas[i]+".csv"
            problem = pd.read_csv(data, encoding='utf-8')  # 另一种方式，直接读入表格
            # print(problem)
            time1 = time.time()
            route, d = IDtspsom(problem, steps)  # 第二参数是迭代次数，route是list
            time2 = time.time()
            dt = time2-time1

            if k == 0:
                dSave[:, i] = d
                tSave[i] = dt
                for j in range(d.size):  # 求收敛步数
                    if np.abs((d[i] - d[-1]) / d[-1]) < 0.0001:
                        convSave[i] = j
                        break
                dMin[i] = np.min((dMin[i], np.min(d)))
                dMax[i] = np.max((dMax[i], d[-1]))
            else:
                dSave[:, i] = (dSave[:, i]*k + d)/(k+1)  # 递推求平均
                tSave[i] = (tSave[i]*k + dt)/(k+1)
                conv = d.size
                for j in range(d.size):  # 求收敛步数
                    if np.abs((d[i] - d[-1]) / d[-1]) < 0.0001:
                        conv = j
                        break
                convSave[i] = (convSave[i] * k + conv) / (k + 1)
                dMin[i] = np.min((dMin[i], np.min(d)))
                dMax[i] = np.max((dMax[i], d[-1]))

    #  画图
    fig = plt.figure()
    plt.rcParams['font.sans-serif'] = ['SimHei']
    plt.rcParams['axes.unicode_minus'] = False

    ax = fig.add_subplot(1, 1, 1)
    # 收敛图
    for i in range(comt):
        ax.plot(dSave[:, i], label=Datas[i], linewidth=1)
    ax.legend(loc='upper right')
    plt.xlabel("steps")
    plt.ylabel("distance/m")
    plt.savefig("./out_files/iterDetail.png", dpi=600, bbox_inches='tight')
    plt.show()
    # 图
    fig = plt.figure()
    plt.rcParams['font.sans-serif'] = ['SimHei']
    plt.rcParams['axes.unicode_minus'] = False
    ax = fig.add_subplot(1, 1, 1)
    # 收敛图
    for i in range(comt):
        ax.plot(dSave[:, i], label=Datas[i], linewidth=1)
    ax.legend(loc='upper right')
    plt.xlabel("steps")
    plt.ylabel("distance/m")
    plt.savefig("./out_files/iter.png", dpi=600, bbox_inches='tight')
    plt.show()


    # 数据写入文件
    file = open("data.txt", mode="w", encoding="utf-8")
    file.write("| 算法 | 平均最优值 | 最差值 | 最好解 | 平均收敛步数 | 执行时间 |\n")
    for i in range(comt):
        file.write("| " + Datas[i]+" | " + str(np.min(dSave[:, i])) +"|" + str(dMax[i]) +" | "+ str(dMin[i]) +" | "+str(convSave[i]) + " | "
                     + str(tSave[i]) + " |\n")
    file.close()













if __name__ == '__main__':
    main()
