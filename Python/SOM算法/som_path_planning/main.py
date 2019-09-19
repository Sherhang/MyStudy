"""
    coding = UTF-8
    author: EE526
    date: 2019.05.27
    description: 用SOM解路径规划问题
    status: TODO
    todo: 两个plot函数，一个单位化，一个实际坐标，写一个反单位化的函数。
          不可行区域
"""

import numpy as np
import pandas as pd

from io_helper import read_tsp, normalize
from neuron import generate_network, get_neighborhood, get_route
from distance import select_closest, euclidean_distance, route_distance
from plot import plot_network, plot_route

ims = []


def main():
    problem = read_tsp('assets\mytest.tsp')  # 打开文件，problem是DataFrame格式
    # problem = pd.read_csv('assets\city20.csv')  # 设置数据类型，city是str)  #
    print(problem)

    route = som(problem, 100000)  # 第二参数是迭代次数，route是list
    np.savetxt('out_files\ route.txt', route, delimiter=',')
    print("route:", route)

    problem = problem.reindex(route)

    distance = route_distance(problem)

    print('Route found of length {}'.format(distance))


def som(problem, iterations, learning_rate=0.8):
    """Solve the TSP using a Self-Organizing Map."""

    # Obtain the normalized set of cities (w/ coord in [0,1])
    cities = problem.copy()
    cities[['x', 'y']] = normalize(cities[['x', 'y']])
    # The population size is 8 times the number of cities   神经元个数
    n = cities.shape[0] * 8
    network = generate_network(n)  # Generate an adequate network of neurons:
    print('Network of {} neurons created. Starting the iterations:'.format(n))

    for i in range(iterations):
        if i == 0 or (not i % 1000):
            plot_network(cities, network, name='out_files\process\city_network%d.png' % (i // 1000 + 1))

        city = cities.sample(1)[['x', 'y']].values  # 随机从cities中选取一组数，1*2数组
        winner_idx = select_closest(network, city)
        # Generate a filter that applies changes to the winner's gaussian
        gaussian = get_neighborhood(winner_idx, n // 10, network.shape[0])
        # Update the network's weights (closer to the city)
        network += gaussian[:, np.newaxis] * learning_rate * (city - network)  # np.newaxis在该位置增加一维，变成神经元数*1维
        # 实际上就是为了让对应的移动乘以对应的坐标
        # Decay the variables
        learning_rate = learning_rate * 0.99997
        n = n * 0.9997

        # Check for plotting interval
        # Check if any parameter has completely decayed.
        if n < 1:
            print('Radius has completely decayed, finishing execution',
                  'at {} iterations'.format(i))
            break
        if learning_rate < 0.001:
            print('Learning rate has completely decayed, finishing execution',
                  'at {} iterations'.format(i))
            break
        # if 神经元覆盖了城市
        #   print('在第{}次迭代，收敛'.format(i))
    else:
        print('Completed {} iterations.'.format(iterations))
    plot_network(cities, network)
    route = get_route(cities, network)
    plot_route(problem[['x', 'y']], route)
    return route


if __name__ == '__main__':
    main()
