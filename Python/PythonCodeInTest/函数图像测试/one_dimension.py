import matplotlib.pyplot as plt
import numpy as np


def func(x):
    # 直接返回函数
    return np.exp(-x*x/(2*155.2*155.2))


def plot_func():
    # param:起点，终点，间距
    x = np.arange(0, 1552//2, 0.01)
    y = func(x)
    plt.plot(x, y)
    plt.show()


if __name__ == '__main__':
    plot_func()
