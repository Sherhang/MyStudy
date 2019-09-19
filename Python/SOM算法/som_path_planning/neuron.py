import numpy as np

from distance import select_closest

def generate_network(size):
    """
    Generate a neuron network of a given size.

    Return a vector of two dimensional points in the interval [0,1].
    生成一个[神经元个数，2]的np数组
    """
    arr = np.linspace(0, 1, size//4)
    arr_0 = np.zeros(size//4)
    arr_1 = np.ones(size//4)
    arr_y = np.concatenate((arr_0, arr, arr_1, arr[:: -1]), axis=0)
    arr_x = np.concatenate((arr, arr_1, arr[::-1], arr_0), axis=0)
    initial_neuron = np.array([arr_x, arr_y]).transpose()  # 数组转置
    return initial_neuron  # edit by EE526 生成一个围绕数据一周的正方形数组
    #return np.random.rand(size, 2)

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
    print('cities', cities)

    return cities.sort_values('winner').index

def completed(cities, network):
    """
    判断是否已经覆盖了城市，如果这样会加大计算量
    :param cities:
    :param network:
    :return:
    """
    print(1)

