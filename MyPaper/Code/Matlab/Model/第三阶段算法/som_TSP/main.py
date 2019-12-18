from sys import argv

import numpy as np
import pandas as pd

from io_helper import read_tsp, normalize
from neuron import generate_network, get_neighborhood, get_route
from distance import select_closest, euclidean_distance, route_distance
from plot import plot_network, plot_route

def main():
    #if len(argv) != 2:       # deleted by EE526
     #   print("inCorrect use: python src/main.py <filename>.tsp")
      #  return -1

    problem = read_tsp('assets\qa194.tsp')  # 打开文件，problem是DataFrame格式
    problem = pd.read_csv('assets\china.csv',encoding='gbk')  # 另一种方式，直接读入表格
    print(problem)

    route = som(problem, 10000)   # 第二参数是迭代次数，route是list
    np.savetxt('out_files\ route.txt', route, delimiter=',')
    print("route:", route)

    problem = problem.reindex(route)

    distance = route_distance(problem)

    print('Route found of length {}'.format(distance))


def som(problem, iterations, learning_rate=0.8):
    """Solve the TSP using a Self-Organizing Map."""

    # Obtain the normalized set of cities (w/ coord in [0,1])
    cities = problem.copy()

    cities[['x', 'y']] = normalize(cities[['x', 'y']])  # 单位化

    # The population size is 8 times the number of cities   神经元个数
    n = cities.shape[0] * 3
    #n = cities.shape[0] * 3   # 测试用，by EE526

    # Generate an adequate network of neurons:
    network = generate_network(n)
    print('Network of {} neurons created. Starting the iterations:'.format(n))

    for i in range(iterations):
        if not i % 100:   # if i%100==0
            print('\t> Iteration {}/{}'.format(i, iterations), end="\r")
        # Choose a random city
        city = cities.sample(1)[['x', 'y']].values   # 随机从cities中选取一组数，1*2数组
        winner_idx = select_closest(network, city)
        # Generate a filter that applies changes to the winner's gaussian
        gaussian = get_neighborhood(winner_idx, n//10, network.shape[0])
        # Update the network's weights (closer to the city)
        network += gaussian[:, np.newaxis] * learning_rate * (city - network)  # np.newaxis在该位置增加一维，变成神经元数*1维
                                                                               # 实际上就是为了让对应的移动乘以对应的坐标
        # Decay the variables
        learning_rate = learning_rate * 0.99997
        n = n * 0.9997

        # Check for plotting interval
        if not i % 1000:      # 每隔1000次画出神经元图像
            plot_network(cities, network, name='out_files\process\city_network%d.png'%(i//1000))

        # Check if any parameter has completely decayed.
        if n < 1:
            print('Radius has completely decayed, finishing execution',
            'at {} iterations'.format(i))
            break
        if learning_rate < 0.001:
            print('Learning rate has completely decayed, finishing execution',
            'at {} iterations'.format(i))
            break
    else:
        print('Completed {} iterations.'.format(iterations))

    plot_network(cities, network)

    route = get_route(cities, network)
    plot_route(cities, route)
    return route

if __name__ == '__main__':
    main()
