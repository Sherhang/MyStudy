from sys import argv

import numpy as np
import pandas as pd
import time
import matplotlib.pyplot as plt

from io_helper import read_tsp, normalize
from neuron import generate_network, get_neighborhood, get_route
from distance import select_closest, euclidean_distance, route_distance
from plot import plot_network, plot_route

def main():
    #if len(argv) != 2:       # deleted by EE526
     #   print("inCorrect use: python src/main.py <filename>.tsp")
      #  return -1
    time1 = time.time()
    problem = read_tsp('assets/usa.tsp')  # 打开文件，problem是DataFrame格式
    # problem = pd.read_csv('assets/a280.csv', encoding='gbk')  # 另一种方式，直接读入表格
    # print(problem)

    route, dSave = som(problem, 50000)   # 第二参数是迭代次数，route是list
    np.savetxt('out_files\ route.txt', route, delimiter=',')
    # print("route:", route)
    time2 = time.time()
    print('Running time: %s Seconds' % (time2 - time1))
    problem = problem.reindex(route)
    distance = route_distance(problem)
    # 画出迭代曲线
    fig = plt.figure()
    plt.rcParams['font.sans-serif'] = ['SimHei']
    plt.rcParams['axes.unicode_minus'] = False
    ax = fig.add_subplot(1, 1, 1)
    ax.plot(dSave, color='red', linewidth=1)
    plt.savefig("./out_files/iter.png", dpi=600, bbox_inches='tight')
    plt.show()
    print('Route found of length {}'.format(distance))


def som(problem, iterations, learning_rate=0.8):
    """Solve the TSP using a Self-Organizing Map."""

    # Obtain the normalized set of cities (w/ coord in [0,1])
    dStep = 100  # 每隔100次保存一次数据
    dSave = np.zeros(iterations // dStep)  # 保存数据
    cities = problem.copy()
    cities[['x', 'y']] = normalize(cities[['x', 'y']])  # 归一化


    # The population size is 8 times the number of cities   神经元个数
    n = cities.shape[0] * 4

    # Generate an adequate network of neurons:
    network = generate_network(cities, n, c=2)
    print('Network of {} neurons created. Starting the iterations:'.format(n))

    for i in range(iterations):
        # Check for plotting interval
        # if i % 100 == 0:      # 每隔100次画出神经元图像
        #     plot_network(cities, network, name='out_files\process\city_network%d.png'%(i//100))

        if not i % 100:   # if i%100==0
            print('\t> Iteration {}/{}'.format(i, iterations), end="\r")
        # Choose a random city
        city = cities.sample(1)[['x', 'y']].values   # 随机从cities中选取一组数，1*2数组
        winner_idx = select_closest(network, city)
        # print(winner_idx)  # DEBUG
        # 改进方案, 获胜神经元距离小于阈值，则直接获胜
        if np.linalg.norm(city - network[winner_idx, :], axis=1) < 0.005:  # 求距离
            network[winner_idx, :] = city
            # print(winner_idx)
        else:
            # Generate a filter that applies changes to the winner's gaussian
            gaussian = get_neighborhood(winner_idx, n // 10, network.shape[0])  # 高斯核函数是算法的核心
            # Update the network's weights (closer to the city)
            network += gaussian[:, np.newaxis] * learning_rate * (city - network)  # np.newaxis在该位置增加一维，变成神经元数*1维
            # 实际上就是为了让对应的移动乘以对应的坐标

        # Decay the variables
        learning_rate = learning_rate * 0.99999
        n = n * 0.9995  # 较好的参数是0.9991-0.9997

        if not i % 100:      # 每隔100次， 求距离
            route = get_route(cities, network)
            p = problem.reindex(route)
            dSave[i // dStep] = route_distance(p)

    else:
        print('Completed {} iterations.'.format(iterations))
    # plot 部分
    plot_network(cities, network)
    route = get_route(cities, network)

    cities = problem.copy()
    citiesReal = cities[['x', 'y']]  # 取实际坐标
    plot_route(citiesReal, route)
    return route, dSave

if __name__ == '__main__':
    main()
