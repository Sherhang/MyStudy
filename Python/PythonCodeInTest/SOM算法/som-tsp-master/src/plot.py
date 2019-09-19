import matplotlib.pyplot as plt
import matplotlib as mpl



def plot_network(cities, neurons, name='out_images\city_path.png', ax=None):
    """Plot a graphical representation of the problem
       cities ：城市坐标
       neurons: 网络层数
       name: 输出图像保存位置
       ax: 图像名称，默认新创建

    """
    mpl.rcParams['agg.path.chunksize'] = 10000

    if not ax:
        fig = plt.figure(figsize=(5, 5), frameon = False)
        axis = fig.add_axes([0,0,1,1])

        axis.set_aspect('equal', adjustable='datalim')
        plt.axis('off')

        axis.scatter(cities['x'], cities['y'], color='red', s=4)
        axis.plot(neurons[:,0], neurons[:,1], 'r.', ls='-', color='#0063ba', markersize=2)

        plt.savefig(name)   # modified by EE526
        """
        plt.ion()   # added by EE526
        plt.show()
        plt.pause(0.01)  # 显示秒数
        #plt.clf()
        plt.close()
        """
        plt.close()

    else:
        ax.scatter(cities['x'], cities['y'], color='red', s=4)
        ax.plot(neurons[:,0], neurons[:,1], 'r.', ls='-', color='#0063ba', markersize=2)
        return ax

def plot_route(cities, route, name='out_images\ route.png', ax=None):
    """Plot a graphical representation of the route obtained"""
    mpl.rcParams['agg.path.chunksize'] = 10000

    if not ax:
        fig = plt.figure(figsize=(5, 5), frameon = False)
        axis = fig.add_axes([0,0,1,1])

        axis.set_aspect('equal', adjustable='datalim')
        plt.axis('off')

        axis.scatter(cities['x'], cities['y'], color='red', s=4)
        route = cities.reindex(route)
        route.loc[route.shape[0]] = route.iloc[0]
        axis.plot(route['x'], route['y'], color='purple', linewidth=1)

        #plt.savefig(name, bbox_inches='tight', pad_inches=0, dpi=200)
        plt.savefig(name)
        plt.show()  # added by EE526
        plt.close()

    else:
        ax.scatter(cities['x'], cities['y'], color='red', s=4)
        route = cities.reindex(route)
        route.loc[route.shape[0]] = route.iloc[0]
        ax.plot(route['x'], route['y'], color='purple', linewidth=1)
        plt.show()  # added by EE526
        return ax
