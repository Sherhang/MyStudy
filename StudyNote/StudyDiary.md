科研记录2019 -2020


# 量子优化算法

## 2019.5.24

https://blog.csdn.net/luqiang_shi/article/details/84672658#2QGApython_62

github项目中import需要修改，sklearn的cross_validation已经被抛弃，需要定位到代码位置修改。只需将 cross_validation 改为 model_selection 即可。

Github地址：

https://github.com/shiluqiang?tab=repositories

里面有几份PSO, GA, QPSO,QGA对SVM算法进行寻优的py代码。

已下载的代码存放在F:\PythonProgram

 

#  一些网站

Github：https://github.com/

Scipy官网：https://docs.scipy.org/doc/scipy/reference/optimize.html

很多科学计算的函数，如优化

编程语言网站：https://www.runoob.com/

清华软件网站：https://mirrors.tuna.tsinghua.edu.cn/

Google开发语言风格https://zh-google-styleguide.readthedocs.io/en/latest/

rpc框架：tars

https://github.com/TarsCloud/Tars

 

Matlab社区文档交换：

https://ww2.mathworks.cn/matlabcentral/fileexchange/48448-fast-linear-assignment-problem-using-auction-algorithm-mex

在这里可以查阅到一些算法的代码

Matlab官方函数说明：

https://ww2.mathworks.cn/help/matlab/ref/find.html

 

交大云盘：

https://jbox.sjtu.edu.cn/

http://mvls.sjtu.edu.cn/

 

# MAtTLAB 语法相关

## Matlab调用c++代码

需要安装mingw编译器，具体安装方法

下载官网mingw编译器，

https://www.mathworks.com/matlabcentral/fileexchange/52848-matlab-support-for-mingw-w64-c-c-compiler

需要登陆matlab账号：交大邮箱，密码常用密码，首字母大写。Matlab账户id：sherhang

![](StudyDiary.assets/clip_image001.png)

安装好之后，先看一个简单的例子：

.cpp实现了一个加法函数，在matlab中调用它。

需要新建一个.cpp文件，#include”mex.h” 然后再添加一个mexFunction函数，这个函数用于连接cpp和matlab，在这个函数里面调用你的cpp, 然后传参就可以。执行mex 文件名   之后，创建了一个.mexw64的文件。这样以后就可以在该目录下调用你自己的cpp函数了。

![](StudyDiary.assets/clip_image003.jpg)

my_add.cpp文件如下：

```c++
#include "mex.h"

    double
    my_add(double x, double y)

{

    return x + y;
}

/*

\*   nlhs 输出参数数目

\*   plhs 指向输出参数的指针

\*   nrhs 输入参数数目

*/

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])

{

    double *a;

    double b, c;

    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);

    a = mxGetPr(plhs[0]);

    b = *(mxGetPr(prhs[0]));

    c = *(mxGetPr(prhs[1]));

    *a = my_add(b, c);
}

```

 

 

## matlab在一个文件定义多个函数和主函数：

文件名和主函数相同，其他函数依次定义即可，可以直接运行。



## matlab修改默认编码格式

matlab默认的编码格式是GBK复制到文本里面中文乱码，feature('locale') 可以查看默认编码格式。

网上的修改方式不适用于matlabr2019

应该是：

打开E:\MATLABR2019a\bin目录下的lcdata_utf8.xml文件

添加

![img](file:///C:/Users/EE526/AppData/Local/Temp/msohtmlclip1/01/clip_image004.png)

删除：

![img](file:///C:/Users/EE526/AppData/Local/Temp/msohtmlclip1/01/clip_image005.png)

还是不行，待解决

另一种方法：中文部分复制到记事本，再复制粘贴就不会乱码了。

官方文档的方法：

**currentCharacterEncoding = slCharacterEncoding()** **返回当前 MATLAB** **字符集编码。**

**slCharacterEncoding(encoding)** **将 MATLAB** **字符集编码更改为指定的 encoding****。**您只能指定以下值：

'US-ASCII'

'Windows-1252'

'ISO-8859-1'

'Shift_JIS'

'UTF-8'

所以在文件前面加上：

slCharacterEncoding('UTF-8')

 

但是复制粘贴需要选只保留文本才行。没有多大意义。不改直接复制粘贴保留文本好像也行。

## 5. 拍卖算法代码测试

Matlab开源社区源码：F:\上海交大\程序19.05.22\MATLAB\算法分类\拍卖算法\auction

最大化指派问题matlab测试数据：

 

```matlab
c =[0.7 0.1 0.1  0.7 0.4 0.7  0.6 0.7 0.8 0.5;

             0.9 0.9 0.8  0.9 0.8 0.9  0.6 0.4 0.3 0.3;

                 0.3 0.7 0    0.9 0.1 0.3  0.6 0.5 0.4 0.8;

           0.1 0.2 0.9  0.7 0.6 0.3   0.6 0.7 0.5 0.5;

           0.8 0.1 0.6  0.7 0.4 0.9   0.4 0.5 0.7 0.8;

           0.2 0.6 0.1  0.7 0.5 0.8   0.9 0.9 0.5 0.4;

           0.4 0.6 0.7  1 0.4 0.9     1 0.3 0.4 0.7;

           0.7 1 0.4    0 0.5 0.7    0.4 0.1 0.3 0.4;

           0.1 0.4 0.3   0.7 0.5 0   0.5 0.9 0.8 0.7;

          0.6 0.1 0.3   0.1 0.7 0.3   0.5 1 0.9 0;]

```

Python测试数据：

```python
c = [[0.7, 0.1, 0.1, 0.7, 0.4, 0.7, 0.6, 0.7, 0.8, 0.5],

        [0.9, 0.9, 0.8, 0.9, 0.8, 0.9, 0.6, 0.4, 0.3, 0.3],

         [0.3, 0.7, 0, 0.9, 0.1, 0.3, 0.6, 0.5, 0.4, 0.8],

        [0.1, 0.2, 0.9, 0.7, 0.6, 0.3, 0.6, 0.7, 0.5, 0.5],

        [ 0.8, 0.1, 0.6, 0.7, 0.4, 0.9, 0.4, 0.5, 0.7, 0.8],

        [0.2, 0.6, 0.1, 0.7, 0.5, 0.8, 0.9, 0.9, 0.5, 0.4],

        [0.4, 0.6, 0.7, 1, 0.4, 0.9, 1, 0.3, 0.4, 0.7],

        [ 0.7, 1, 0.4, 0, 0.5, 0.7, 0.4, 0.1, 0.3, 0.4],

        [0.1, 0.4, 0.3, 0.7, 0.5, 0, 0.5, 0.9, 0.8, 0.7],

        [0.6, 0.1, 0.3, 0.1, 0.7, 0.3, 0.5, 1, 0.9, 0]

     ]
```

```python
最大值是8.8，已知解[1 8 4 7 2 5 6 9 10 3]，

[1 8 4 7 2 5 6 10 9 3]，

[2 8 4 7 10 5 6 9 1 3]

匈牙利算法的结果是固定行号，列号是结果 [ 9  1 10  3  6  7  4  2  8  5]。表示行号【1 2 3 4。。。。】对应列号[9 1 10….]


```

 

```matlab
对开源社区代码测试：

AuctionJacobi.m 结果错误，未得到最大值

测试auction，在前面添加测试数据
w = [0.7 0.1 0.1  0.7 0.4 0.7  0.6 0.7 0.8 0.5;

           0.9 0.9 0.8  0.9 0.8 0.9  0.6 0.4 0.3 0.3;

			0.3 0.7 0    0.9 0.1 0.3  0.6 0.5 0.4 0.8;

           0.1 0.2 0.9  0.7 0.6 0.3   0.6 0.7 0.5 0.5;

           0.8 0.1 0.6  0.7 0.4 0.9   0.4 0.5 0.7 0.8;

           0.2 0.6 0.1  0.7 0.5 0.8   0.9 0.9 0.5 0.4;

           0.4 0.6 0.7  1 0.4 0.9     1 0.3 0.4 0.7;

           0.7 1 0.4    0 0.5 0.7    0.4 0.1 0.3 0.4;

           0.1 0.4 0.3   0.7 0.5 0   0.5 0.9 0.8 0.7;

           0.6 0.1 0.3   0.1 0.7 0.3   0.5 1 0.9 0;]

直接运行，结果8.8【2     8     4     7    10     5     6     9     1     3】

补充：nargin指调用函数的个数，缩写，直接运行则nargin=0

调用格式：[ won bet happy tt ] = auction( w, iter, e, verbose )

w=[4  3  4;1  4  4;4  8  4];4次可以出结果，e=0.1
```



## 6. SOM算法

GitHub源码：https://github.com/DiegoVicen/som-tsp

理解参见：https://mp.weixin.qq.com/s/O7UHeTFfcJ1FjNShVe9wtA

可解决TSP问题，距离衡量用欧几里得距离，且已经单位化，所以也是余弦相似度。

 

SOM算法基本知识：无监督学习，一般用于降维，数据可视化，聚类

https://blog.csdn.net/weixin_38347387/article/details/80342662

博客中例子理解：每一次循环，对于每个点，找到模获胜神经元w，然后让w靠近点，这个点就属于神经元w的类。这个例子学习因子是固定的。好的做法是设定一个衰减。同时，靠近程度应该是越近的影响越大才对。

进一步理解，SOM是一种降维。SOM网经过训练以后，在高维空间输入相近的样本，其输出相应的位置也相近。第二个例子。

SOM应用到TSP：

将神经元排成圆形，而非网络。同时让神经元的个数等于城市的个数，而此时城市其实也是聚类样本。只需要稍作修改，在邻域函数的作用下，自组织映射就会像一个弹性圆圈，不断靠近城市，同时尽量缩小总长度。

算法实现：

get_neighborhood(center, radix, domain):函数内部图像为

![](StudyDiary.assets/clip_image007.jpg)

右端点为神经元个数//2。

 如何得到路径？取最后一次，按照获胜神经元的序号，依次取离它最近的城市坐标，排列好就是路径顺序。值得思考的是：为什么最后神经元一定按照初始创建的顺序序号排列好？初始位置是随机的。原因在于距离的定义：源代码中，距离是按照序号距离来定义的，那么序号靠近的相互之间作用大，序号越近越容易最后靠在一起。所以SOM用于TSP是一个几何算法。

![](StudyDiary.assets/clip_image009.jpg)

总结一下这个算法：

Step1: 从city列表随机选一个，找出离他最近的神经元。

Step2: 计算获胜神经元周围的神00.经元移动的系数，获胜的是1， 序号离他越远这个值越小，接近0，就是上面的函数图像。可以这样理解：把神经元按照序号排成一个圆，那么对面的离它最远。

Step3: 神经元位置更新，用上面的系数 * 选中的city坐标-每个neuron坐标。

Step4: 迭代多次，得到city-获胜神经元列表，计算路径。![](StudyDiary.assets/clip_image010.png)

 

思考：

1． 收敛准则：如果获胜神经元坐标都覆盖了城市坐标，那么已经得到最优解了。可以改进。

2． 如果在地图里面加入不可行区域会怎么样？

## matplotlib 画图

https://www.runoob.com/numpy/numpy-matplotlib.html

https://www.runoob.com/w3cnote/matplotlib-tutorial.html

### 静态图png

导入模块一般

import numpy as np

import matplotlib.pyplot as plt

如果用import pylab import * ,接近matlab，但是不推荐用。

三种画图方式：pyplot函数式,  pylab,  类封装

用类封装的方式更接近底层，推荐。

https://blog.csdn.net/wj1066/article/details/78896019

但是最常用的还是

import numpy as np

import matplotlib.pyplot as plt

 

推荐查看matplotlib画廊：https://matplotlib.org/gallery.html

 

目前就用这个吧。

函数图像等图

画图之前加上

plt.rcParams['font.sans-serif']=['SimHei']

plt.rcParams['axes.unicode_minus'] = False

可以正常显示中文和正负号

Title, label, ticklabel

 

 

**line1 = ax.plot(x, y, color=’red’, linestyle='-', linewidth=2 ,dashes=[30, 5, 10, 5],**

**label='****我的标签')**

\# ’-‘设置线形，可以多样，如’--'虚线，’-*’，甚至’-2’等，记住’—’ ‘-.’ ‘:’ ‘-‘

\# dashes=[a,b,c,d]表示虚线设置，画a个点，b个空，再画出c个，d个空，这样就能实现自定义虚线。

\# label 标签名，出现在线条旁边

 

**ax.scatter(x, y, c=color, s=scale,  marker=’’,  label=str(color),  # scale****对应每个点的大小**

​               **alpha=0.5, edgecolors='none')   # alpha** **是颜色深度，值越大颜色越深**

**marker****的值**

![../../_images/marker_reference_00.png](file:///C:/Users/EE526/AppData/Local/Temp/msohtmlclip1/01/clip_image012.jpg)![../../_images/marker_reference_01.png](file:///C:/Users/EE526/AppData/Local/Temp/msohtmlclip1/01/clip_image014.jpg)

 

### plt 绘制动图以及gif

https://blog.csdn.net/qq_28888837/article/details/85778395

 

```python
import matplotlib.animation as animation

import matplotlib.pyplot as plt

ims = []

fig = plt.figure()

for i in range(1,10):

    im = plt.scatter(1,1).findobj()  # scatter要加findobj(),  plot不用

    ims.append(im)

ani = animation.ArtistAnimation(fig, ims, interval=200, repeat_delay=1000)

ani.save("test1.gif", writer='pillow')
```

 

# 分配算法代码测试

MATLAB 写文件进入txt

```matlab
% 记录日志

fid = fopen('log.txt','a');  % a追加写

t=datetime;

fprintf(fid,datestr(t));

fprintf(fid,'\n');

fclose(fid);
```

 

拍卖算法误差是n*e, 所以用1/n

测试代码主要包括：auction, munkres（KM）,q, base

 

# 聚类算法思考

任务分配的第一阶段如果是聚类怎么用？聚类目标与约束？现对匈牙利算法针对多机多目标进行仿真，Python代码测试，目标：每个飞机目标数量有上限，使得总距离和最小。

# LaTeX安装

https://blog.csdn.net/sleepingemperor/article/details/80394018

![](StudyDiary.assets/clip_image015.png)

 

```latex
\documentclass[UTF8]{ctexart}

\begin{document}

$
k'(x)=\lim_{\Delta x\to 0}\frac{k(x)-k(x-\Delta x)}{\Delta x}
$

\end{document}
```


$$
k'(x)=\lim_{\Delta x\to 0}\frac{k(x)-k(x-\Delta x)}{\Delta x}
$$
Tex数学公式

https://blog.csdn.net/u013346007/article/details/54138690

 

# 数据集

## TSP数据集

https://my.oschina.net/ahaoboy/blog/1823450

测试一下py 的SOM算法

 

