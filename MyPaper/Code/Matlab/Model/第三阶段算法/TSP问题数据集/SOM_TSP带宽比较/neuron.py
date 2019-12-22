import numpy as np
import pandas as pd

from distance import select_closest

def generate_network(cities, n, c=0):
    """
    Generate a neuron network of a given size.
    Return a vector of two dimensional points in the interval [0,1].
    生成一个[神经元个数，2]的np数组
    cities 归一化后的数据
    n, 神经元个数，一般去cities 个数*（3-8）

    c=0, 随机生成
    c=1，生成一个圆环
    c=2，生成一个有序圆环
    c=3, 随cities而生成
    c=4, 生成一个正方形
    """
    city = cities[['x', 'y']]
    ret = np.random.rand(n, 2)
    if c == 1:
        theta = np.random.rand(n) * 2.0 * np.pi
        a = 0.5+0.4*np.cos(theta)
        b = 0.5+0.4*np.sin(theta)
        a = a[:, np.newaxis]
        b = b[:, np.newaxis]
        ret = np.concatenate((a, b), axis=1)  # 无序的圆环

    if c == 2:
        r = 0.3
        theta = np.arange(n)/n * 2.0 * np.pi
        a = 0.5+r*np.cos(theta)
        b = 0.5+r*np.sin(theta)
        a = a[:, np.newaxis]
        b = b[:, np.newaxis]
        ret = np.concatenate((a, b), axis=1)  # 有序的圆环，指序号和角度之间的关系是有序的，效果最好

    if c == 3:    # 按照数据的分布得到的离散点
        k = n//cities.shape[0]
        cities3 = city
        for i in range(0, k-1):
            cities3 = cities3.append(city, ignore_index=True)
        print(cities3.shape)
        ret = cities3 + 0.1*np.random.rand(cities.shape[0]*k, 2)
        ret = ret.values  # DataFrame转成np数组

    if c == 4:
        num = n//4  # 每条边的个数
        a = np.arange(num)/num
        b = np.zeros(num)
        c = np.ones(num)
        a = a[:, np.newaxis]
        b = b[:, np.newaxis]
        c = c[:, np.newaxis]
        ret = np.zeros(shape=(num*4, 2))
        ret[0:num, :] = np.concatenate((a, c), axis=1)  # 上边
        ret[num:2*num, :] = np.concatenate((c, a[::-1]), axis=1)  # 右边
        ret[2*num:3*num, :] = np.concatenate((a[::-1], b), axis=1)  # 下边 https://www.cnblogs.com/yuxuanlian/p/numpy.html
        ret[3*num:4*num, :] = np.concatenate((b, a), axis=1)  # 左边

    return ret  #


def get_neighborhood(center, radix, domain):
    """Get the range gaussian of given radix around a center index.
       inputs：
             center： 获胜神经元的序号，一个数字
             radix： 基数，main()调用点设置为 神经元个数//10。
             domain: 神经元个数
       outputs:
             高斯衰减函数，以获胜神经元为中心，离得越近的影响越大
    """

    # Impose an upper bound on the radix to prevent NaN and blocks
    if radix < 1:
        radix = 1

    # Compute the circular network distance to the center
    deltas = np.absolute(center - np.arange(domain))
    distances = np.minimum(deltas, domain - deltas)  # 这一步是因为神经元按照圆形排列，那么距离应该按照原环来算。

    # Compute Gaussian distribution around the given center
    return np.exp(-(distances*distances) / (2*(radix*radix)))

def get_route(cities, network):
    """Return the route computed by a network."""
    cities['winner'] = cities[['x', 'y']].apply(
        lambda c: select_closest(network, c),
        axis=1, raw=True)
    # print('cities', cities)

    return cities.sort_values('winner').index
