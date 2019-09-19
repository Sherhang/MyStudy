"""
    新增model2，用于求最小距离和
    2019.5.29 by EE526
    可以当做一种新的聚类算法
"""
from model import Situation, Model, Model2
import numpy as np
import math
import matplotlib.pyplot as plt
from scipy.optimize import linear_sum_assignment


def max_assign(plane_list, target_list, superiority):
    """
    求最大收益
    :param plane_list: 飞机序列
    :param target_list: 目标序列
    :param superiority: 广义矩阵
    :return: 最优方案和最优值
    """
    max_val = np.max(superiority)
    cost = max_val - superiority
    (row_ind, col_ind) = linear_sum_assignment(cost)
    best_row = []
    for i in row_ind:
        best_row.append(plane_list[i])
    best_col = []
    for i in col_ind:
        best_col.append(target_list[i])
    best_val = superiority[row_ind, col_ind].sum()
    best_plan = np.asarray([best_row, best_col])
    return best_plan, best_val



def min_assign(plane_list, target_list, superiority):
    """
    求最小距离和
    :param plane_list: 飞机序列
    :param target_list: 目标序列
    :param superiority: 广义矩阵
    :return: 最优方案和最优值
    """
    cost = superiority
    (row_ind, col_ind) = linear_sum_assignment(cost)
    best_row = []
    for i in row_ind:
        best_row.append(plane_list[i])
    best_col = []
    for i in col_ind:
        best_col.append(target_list[i])
    best_val = superiority[row_ind, col_ind].sum()
    best_plan = np.asarray([best_row, best_col])
    return best_plan, best_val


if __name__ == "__main__":
    num_plane = 4
    num_target = 40
    # 随机生成态势信息
    pm = np.random.random([num_plane, 2])*500.0
    pm[:, 1] = 0
    am = np.linspace(30, 120, num_plane)
    vm = np.random.randint(1, 3, [num_plane]) * 0.3
    m_num = np.random.randint(10, 12, [num_plane])
    #print("导弹数量", m_num)
    pn = np.random.random([num_target, 2])*500.0+100
    pn[1:4, 1] = 600.0
    an = np.linspace(70, 200, num_target)
    vn = np.random.randint(1, 2, [num_target]) * 0.1
    priority = np.random.randint(1, 2, [num_target], dtype=int)
    #print("priority", priority)
	
    situ = Situation(pm, am, vm, m_num, pn, an, vn, priority)  # 模型初始化，类封装
    m = Model2()   # 选取模型2，求最短距离，注意在下面要调用min_assign
    (plane_list, target_list, superiority) = m.get_matrix(situ)
    print(plane_list)
    print(target_list)
    #print(superiority)

    (best_plan, best_val) = min_assign(plane_list, target_list, superiority)
    print("方案")
    print(best_plan)
    print(best_val)
    """
    画图
    """
    #print("飞机位置", pm)
    plt.rcParams['font.sans-serif'] = ['SimHei']
    plt.rcParams['axes.unicode_minus'] = False
    plt.scatter(pm[:, 0], pm[:, 1], color='r', label='无人机位置')
    plt.scatter(pn[:, 0], pn[:, 1], color='g', label='目标位置')
    plt.legend(loc='upper right')
    plt.quiver(pm[:, 0], pm[:, 1], np.cos(am/360*2*np.pi), np.sin(am/360*2*math.pi))
    plt.quiver(pn[:, 0], pn[:, 1], np.cos(an/360*2*math.pi), np.sin(an/360*2*math.pi))
    for i in range(best_plan.shape[1]):
        plt.plot([pm[best_plan[0, i], 0], pn[best_plan[1, i], 0]],
                 [pm[best_plan[0, i], 1], pn[best_plan[1, i], 1]], color='y')
    plt.show()





