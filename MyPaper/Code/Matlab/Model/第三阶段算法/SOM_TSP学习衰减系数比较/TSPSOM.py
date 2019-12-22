from sys import argv

import numpy as np
import pandas as pd


from io_helper import read_tsp, normalize
from neuron import generate_network, get_neighborhood, get_route
from distance import select_closest, euclidean_distance, route_distance
from plot import plot_network, plot_route


def tspsom(problem, iterations, learning_rate=0.8, dsigma=0.9997):
    """Solve the TSP using a Self-Organizing Map.
        基本形式，神经元数量等于n
    """
    # Obtain the normalized set of cities (w/ coord in [0,1])
    cities = problem.copy()
    dStep = 100  # 每隔100次保存一次数据
    dSave = np.zeros(iterations // dStep)  # 保存数据
    cities[['x', 'y']] = normalize(cities[['x', 'y']])  # 归一化
    # The population size is 8 times the number of cities   神经元个数
    n = cities.shape[0] * 1

    # Generate an adequate network of neurons:
    network = generate_network(cities, n, c=0)
    print('Network of {} neurons created. Starting the iterations:'.format(n))

    for i in range(iterations):
        city = cities.sample(1)[['x', 'y']].values   # 随机从cities中选取一组数，1*2数组
        winner_idx = select_closest(network, city)
        gaussian = get_neighborhood(winner_idx, n // 10, network.shape[0])  # 高斯核函数是算法的核心
        network += gaussian[:, np.newaxis] * learning_rate * (city - network)  # np.newaxis在该位置增加一维，变成神经元数*1维, 实际上就是为了让对应的移动乘以对应的坐标
        # Decay the variables
        learning_rate = learning_rate * 0.99997
        n = n * dsigma  # 较好的参数是0.9991-0.9997

        if not i % 100:      # 每隔100次， 求距离
            route = get_route(cities, network)
            p = problem.reindex(route)
            dSave[i // dStep] = route_distance(p)

        # Check if any parameter has completely decayed.
    #     if n < 1:
    #         print('Radius has completely decayed, finishing execution',
    #         'at {} iterations'.format(i))
    #         break
    #     if learning_rate < 0.001:
    #         print('Learning rate has completely decayed, finishing execution',
    #         'at {} iterations'.format(i))
    #         break
    else:
        print('Completed {} iterations.'.format(iterations))
    route = get_route(cities, network)
    return route, dSave


def Mtspsom(problem, iterations, learning_rate=0.8):
    """Solve the TSP using a Self-Organizing Map.
        基本形式，神经元数量等于n*3
    """
    # Obtain the normalized set of cities (w/ coord in [0,1])
    cities = problem.copy()
    dStep = 100  # 每隔100次保存一次数据
    dSave = np.zeros(iterations // dStep)  # 保存数据
    cities[['x', 'y']] = normalize(cities[['x', 'y']])  # 归一化
    # The population size is 8 times the number of cities   神经元个数
    n = cities.shape[0] * 3

    # Generate an adequate network of neurons:
    network = generate_network(cities, n, c=0)
    print('Network of {} neurons created. Starting the iterations:'.format(n))

    for i in range(iterations):
        city = cities.sample(1)[['x', 'y']].values   # 随机从cities中选取一组数，1*2数组
        winner_idx = select_closest(network, city)
        gaussian = get_neighborhood(winner_idx, n // 10, network.shape[0])  # 高斯核函数是算法的核心
        network += gaussian[:, np.newaxis] * learning_rate * (city - network)  # np.newaxis在该位置增加一维，变成神经元数*1维, 实际上就是为了让对应的移动乘以对应的坐标
        # Decay the variables
        learning_rate = learning_rate * 0.99997
        n = n * 0.9998  # 较好的参数是0.9991-0.9997

        if not i % 100:      # 每隔100次， 求距离
            route = get_route(cities, network)
            p = problem.reindex(route)
            dSave[i // dStep] = route_distance(p)

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
    route = get_route(cities, network)
    return route, dSave


def  Stspsom(problem, iterations, learning_rate=0.8):
    """Solve the TSP using a Self-Organizing Map.
        方形， n*2
    """
    # Obtain the normalized set of cities (w/ coord in [0,1])
    cities = problem.copy()
    dStep = 100  # 每隔100次保存一次数据
    dSave = np.zeros(iterations // dStep)  # 保存数据
    cities[['x', 'y']] = normalize(cities[['x', 'y']])  # 归一化
    # The population size is 8 times the number of cities   神经元个数
    n = cities.shape[0] * 2

    # Generate an adequate network of neurons:
    network = generate_network(cities, n, c=4)
    print('Network of {} neurons created. Starting the iterations:'.format(n))

    for i in range(iterations):
        city = cities.sample(1)[['x', 'y']].values   # 随机从cities中选取一组数，1*2数组
        winner_idx = select_closest(network, city)
        gaussian = get_neighborhood(winner_idx, n // 10, network.shape[0])  # 高斯核函数是算法的核心
        network += gaussian[:, np.newaxis] * learning_rate * (city - network)  # np.newaxis在该位置增加一维，变成神经元数*1维, 实际上就是为了让对应的移动乘以对应的坐标
        # Decay the variables
        learning_rate = learning_rate * 0.99997
        n = n * 0.9997  # 较好的参数是0.9991-0.9997

        if not i % 100:      # 每隔100次， 求距离
            route = get_route(cities, network)
            p = problem.reindex(route)
            dSave[i // dStep] = route_distance(p)

        # # Check if any parameter has completely decayed.
        # if n < 1:
        #     print('Radius has completely decayed, finishing execution',
        #     'at {} iterations'.format(i))
        #     break
        # if learning_rate < 0.001:
        #     print('Learning rate has completely decayed, finishing execution',
        #     'at {} iterations'.format(i))
        #     break
    else:
        print('Completed {} iterations.'.format(iterations))
    route = get_route(cities, network)
    return route, dSave


def Ctspsom(problem, iterations, learning_rate=0.8):
    """Solve the TSP using a Self-Organizing Map.
        有序圆形， n*1
    """
    # Obtain the normalized set of cities (w/ coord in [0,1])
    cities = problem.copy()
    dStep = 100  # 每隔100次保存一次数据
    dSave = np.zeros(iterations // dStep)  # 保存数据
    cities[['x', 'y']] = normalize(cities[['x', 'y']])  # 归一化
    # The population size is 8 times the number of cities   神经元个数
    n = cities.shape[0] * 1

    # Generate an adequate network of neurons:
    network = generate_network(cities, n, c=2)
    print('Network of {} neurons created. Starting the iterations:'.format(n))

    for i in range(iterations):
        city = cities.sample(1)[['x', 'y']].values   # 随机从cities中选取一组数，1*2数组
        winner_idx = select_closest(network, city)
        gaussian = get_neighborhood(winner_idx, n // 10, network.shape[0])  # 高斯核函数是算法的核心
        network += gaussian[:, np.newaxis] * learning_rate * (city - network)  # np.newaxis在该位置增加一维，变成神经元数*1维, 实际上就是为了让对应的移动乘以对应的坐标
        # Decay the variables
        learning_rate = learning_rate * 0.99997
        n = n * 0.9995  # 较好的参数是0.9991-0.9997

        if not i % 100:      # 每隔100次， 求距离
            route = get_route(cities, network)
            p = problem.reindex(route)
            dSave[i // dStep] = route_distance(p)

        # Check if any parameter has completely decayed.
        # if n < 1:
        #     print('Radius has completely decayed, finishing execution',
        #     'at {} iterations'.format(i))
        #     break
        # if learning_rate < 0.001:
        #     print('Learning rate has completely decayed, finishing execution',
        #     'at {} iterations'.format(i))
        #     break
    else:
        print('Completed {} iterations.'.format(iterations))
    route = get_route(cities, network)
    return route, dSave


def Dtspsom(problem, iterations, learning_rate=0.8):
    """Solve the TSP using a Self-Organizing Map.
        密度， n*3
    """
    # Obtain the normalized set of cities (w/ coord in [0,1])
    cities = problem.copy()
    dStep = 100  # 每隔100次保存一次数据
    dSave = np.zeros(iterations // dStep)  # 保存数据
    cities[['x', 'y']] = normalize(cities[['x', 'y']])  # 归一化
    # The population size is 8 times the number of cities   神经元个数
    n = cities.shape[0] * 3

    # Generate an adequate network of neurons:
    network = generate_network(cities, n, c=3)
    print('Network of {} neurons created. Starting the iterations:'.format(n))

    for i in range(iterations):
        city = cities.sample(1)[['x', 'y']].values   # 随机从cities中选取一组数，1*2数组
        winner_idx = select_closest(network, city)
        gaussian = get_neighborhood(winner_idx, n // 10, network.shape[0])  # 高斯核函数是算法的核心
        network += gaussian[:, np.newaxis] * learning_rate * (city - network)  # np.newaxis在该位置增加一维，变成神经元数*1维, 实际上就是为了让对应的移动乘以对应的坐标
        # Decay the variables
        learning_rate = learning_rate * 0.99997
        n = n * 0.9995  # 较好的参数是0.9991-0.9997

        if not i % 100:      # 每隔100次， 求距离
            route = get_route(cities, network)
            p = problem.reindex(route)
            dSave[i // dStep] = route_distance(p)

        # # Check if any parameter has completely decayed.
        # if n < 1:
        #     print('Radius has completely decayed, finishing execution',
        #     'at {} iterations'.format(i))
        #     break
        # if learning_rate < 0.001:
        #     print('Learning rate has completely decayed, finishing execution',
        #     'at {} iterations'.format(i))
        #     break
    else:
        print('Completed {} iterations.'.format(iterations))
    route = get_route(cities, network)
    return route, dSave


def IStspsom(problem, iterations, learning_rate=0.8):
    """Solve the TSP using a Self-Organizing Map.
        使用方形+渗透,n*3
    """
    # Obtain the normalized set of cities (w/ coord in [0,1])
    cities = problem.copy()
    dStep = 100  # 每隔100次保存一次数据
    dSave = np.zeros(iterations // dStep)  # 保存数据
    cities[['x', 'y']] = normalize(cities[['x', 'y']])  # 归一化
    # The population size is 8 times the number of cities   神经元个数
    n = cities.shape[0] * 3

    # Generate an adequate network of neurons:
    network = generate_network(cities, n, c=4)
    print('Network of {} neurons created. Starting the iterations:'.format(n))

    for i in range(iterations):
        city = cities.sample(1)[['x', 'y']].values   # 随机从cities中选取一组数，1*2数组
        winner_idx = select_closest(network, city)
        # 改进方案, 获胜神经元距离小于阈值，则直接获胜
        if np.linalg.norm(city - network[winner_idx, :], axis=1) < 0.005:  # 求距离
            network[winner_idx, :] = city
            # print(winner_idx)
        else:
            gaussian = get_neighborhood(winner_idx, n // 10, network.shape[0])  # 高斯核函数是算法的核心
            network += gaussian[:, np.newaxis] * learning_rate * (city - network)  # np.newaxis在该位置增加一维，变成神经元数*1维
            # 实际上就是为了让对应的移动乘以对应的坐标
        # Decay the variables
        learning_rate = learning_rate * 0.99997
        n = n * 0.9995  # 较好的参数是0.9991-0.9997

        if not i % 100:      # 每隔100次， 求距离
            route = get_route(cities, network)
            p = problem.reindex(route)
            dSave[i // dStep] = route_distance(p)

        # # Check if any parameter has completely decayed.
        # if n < 1:
        #     print('Radius has completely decayed, finishing execution',
        #     'at {} iterations'.format(i))
        #     break
        # if learning_rate < 0.001:
        #     print('Learning rate has completely decayed, finishing execution',
        #     'at {} iterations'.format(i))
        #     break
    else:
        print('Completed {} iterations.'.format(iterations))
    route = get_route(cities, network)
    return route, dSave


def ICtspsom(problem, iterations, learning_rate=0.8):
    """Solve the TSP using a Self-Organizing Map.
        使用圆形+渗透,n*3
    """
    # Obtain the normalized set of cities (w/ coord in [0,1])
    cities = problem.copy()
    dStep = 100  # 每隔100次保存一次数据
    dSave = np.zeros(iterations // dStep)  # 保存数据
    cities[['x', 'y']] = normalize(cities[['x', 'y']])  # 归一化
    # The population size is 8 times the number of cities   神经元个数
    n = cities.shape[0] * 3

    # Generate an adequate network of neurons:
    network = generate_network(cities, n, c=2)
    print('Network of {} neurons created. Starting the iterations:'.format(n))

    for i in range(iterations):
        city = cities.sample(1)[['x', 'y']].values   # 随机从cities中选取一组数，1*2数组
        winner_idx = select_closest(network, city)
        # 改进方案, 获胜神经元距离小于阈值，则直接获胜
        if np.linalg.norm(city - network[winner_idx, :], axis=1) < 0.005:  # 求距离
            network[winner_idx, :] = city
            # print(winner_idx)
        else:
            gaussian = get_neighborhood(winner_idx, n // 10, network.shape[0])  # 高斯核函数是算法的核心
            network += gaussian[:, np.newaxis] * learning_rate * (city - network)  # np.newaxis在该位置增加一维，变成神经元数*1维
            # 实际上就是为了让对应的移动乘以对应的坐标
        # Decay the variables
        learning_rate = learning_rate * 0.99997
        n = n * 0.9995  # 较好的参数是0.9991-0.9997

        if not i % 100:      # 每隔100次， 求距离
            route = get_route(cities, network)
            p = problem.reindex(route)
            dSave[i // dStep] = route_distance(p)

    #     # Check if any parameter has completely decayed.
    #     if n < 1:
    #         print('Radius has completely decayed, finishing execution',
    #         'at {} iterations'.format(i))
    #         break
    #     if learning_rate < 0.001:
    #         print('Learning rate has completely decayed, finishing execution',
    #         'at {} iterations'.format(i))
    #         break
    # else:
        print('Completed {} iterations.'.format(iterations))
    route = get_route(cities, network)
    return route, dSave


def IDtspsom(problem, iterations, learning_rate=0.8, dsigma=0.9995, dalpha=0.99997):
    """Solve the TSP using a Self-Organizing Map.
        密度+渗透，n*3
    """
    # Obtain the normalized set of cities (w/ coord in [0,1])
    cities = problem.copy()
    dStep = 100  # 每隔100次保存一次数据
    dSave = np.zeros(iterations // dStep)  # 保存数据
    cities[['x', 'y']] = normalize(cities[['x', 'y']])  # 归一化
    # The population size is 8 times the number of cities   神经元个数
    n = cities.shape[0] * 3

    # Generate an adequate network of neurons:
    network = generate_network(cities, n, c=3)
    print('Network of {} neurons created. Starting the iterations:'.format(n))

    for i in range(iterations):
        city = cities.sample(1)[['x', 'y']].values   # 随机从cities中选取一组数，1*2数组
        winner_idx = select_closest(network, city)
        # 改进方案, 获胜神经元距离小于阈值，则直接获胜
        if np.linalg.norm(city - network[winner_idx, :], axis=1) < 0.005:  # 求距离
            network[winner_idx, :] = city
            # print(winner_idx)
        else:
            gaussian = get_neighborhood(winner_idx, n // 10, network.shape[0])  # 高斯核函数是算法的核心
            network += gaussian[:, np.newaxis] * learning_rate * (city - network)  # np.newaxis在该位置增加一维，变成神经元数*1维
            # 实际上就是为了让对应的移动乘以对应的坐标
        # Decay the variables
        learning_rate = learning_rate * dalpha
        n = n * dsigma  # 较好的参数是0.9991-0.9997

        if not i % 100:      # 每隔100次， 求距离
            route = get_route(cities, network)
            p = problem.reindex(route)
            dSave[i // dStep] = route_distance(p)

        # # Check if any parameter has completely decayed.
        # if n < 1:
        #     print('Radius has completely decayed, finishing execution',
        #     'at {} iterations'.format(i))
        #     break
        # if learning_rate < 0.001:
        #     print('Learning rate has completely decayed, finishing execution',
        #     'at {} iterations'.format(i))
        #     break
    else:
        print('Completed {} iterations.'.format(iterations))
    route = get_route(cities, network)
    return route, dSave

