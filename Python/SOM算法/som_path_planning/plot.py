import matplotlib.pyplot as plt
from matplotlib.ticker import MultipleLocator, FormatStrFormatter
import matplotlib.animation as animation


def plot_network(cities_normalize, neurons, name='out_files\city_network.png', ax=None):
    """Plot a graphical representation of the problem
       cities_normalize: 归一化的坐标, 是DataFrame: 'city','x','y'
       neurons: 神经元坐标， np数组，n*2
       name: 输出图像保存位置
       ax: 图像名称，默认新创建, 用ax可以提升画图速度
    """
    fig, ax = plt.subplots()
    plt.axis([-0.1, 1.1, -0.1, 1.1])
    ax.xaxis.set_major_locator(MultipleLocator(0.1))  # x刻度为1.5的倍数
    plt.xlabel(r'x', fontsize=15, color='black')
    plt.ylabel(r'y', fontsize=15, color='black', rotation='horizontal')  # 水平显示ylabel, 默认垂直

    ax.scatter(cities_normalize['x'], cities_normalize['y'],  c='r', s=5, marker="^", label='cities', alpha=0.8)
    ax.scatter(neurons[:, 0], neurons[:, 1], c='b', s=5, label='neurons', alpha=0.5)
    ax.legend(loc='upper right')  # label 的位置
    im = plt.savefig(fname=name, dpi=None)
    #ims.append[im]  # 全局变量
    # ani = animation.ArtistAnimation(fig,ims, interval=200, repeat_delay=1000)
    plt.close()
    return fig

def plot_route(cities, route, name='out_files\ route.png', ax=None):
    """

    :param cities: DataFrame
    :param route: 1维数组
    :param name:
    :param ax:
    :return:
    """
    fig, ax = plt.subplots()
    plt.axis([cities['x'].min()-10, cities['x'].max()+10, cities['y'].min()-10, cities['y'].max()+10])
    ax.xaxis.set_major_locator(MultipleLocator(100))  # x刻度为1.5的倍数
    ax.yaxis.set_major_locator(MultipleLocator(100))
    plt.xlabel(r'x', fontsize=15, color='black')
    plt.ylabel(r'y', fontsize=15, color='black', rotation='horizontal')  # 水平显示ylabel, 默认垂直

    route = cities.reindex(route)
    route.loc[route.shape[0]] = route.iloc[0]  # 加上最后一条路，加了一行，把第一行复制加到末尾
    plt.scatter(cities['x'], cities['y'],  c='r', marker="^", label='cities')
    plt.plot(route['x'], route['y'], c='b', label='route')
    plt.legend(loc='upper right')
    plt.savefig(fname=name, dpi=None)
    #plt.show()
    plt.close()