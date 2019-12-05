

### 1. Research on Task Assignment Optimization Algorithm Based on Multi-Agent

Jie Zhang1,Gang Wang2,Xiaoqiang Yao2, Yafei Song1, Fangzheng Zhao1

 

来源：https://ieeexplore.ieee.org/document/8623121

模型：多智能体任务分配，多目标，收益，损失，

目标函数：收益-损失

算法：拍卖算法

### 2. 拍卖算法研究及其应用

这篇对算法理论进行了细致证明，可以参考。

拍卖算法参考https://blog.csdn.net/vict_wang/article/details/86584435

博客里用的更新公式不太好，因为无法保证误差。

拍卖算法过程：

给定价格矩阵w, 求最大化指派。列代表物品，行代表竞拍者。矩阵值代表竞拍者认为该物品可以值的价格，可以这样理解，竞拍者可以以这个价格再卖给别人。所以每个人都想得到物品，买下来的价格p越小越好。

更新过程如下：

p 物品的价格向量，初始全为0，竞拍不断加价。

won 竞拍者，won=[0,1,0]代表1号竞拍者得到2号物品。0代表没有人。

q 剩余竞拍者队列，还没有得到物品的人。最好的实现方式是队列，程序中用数组。

每次从q选取一个没有得到物品的人，算每个物品对该人可以有多大利润，选取最大的。直到所有人都分到物品。调试过后的代码放在 MATLAB\算法分类\拍卖算法\AuctionJacobi

![](PaperNote.assets/clip_image002.jpg)

竞拍者i 的满意度指i行有利润大于0的物品就可以，或者在该行，选中的物品价值加上e是最大的。满意度值是0或者1。

这个算法在e取太大时会出错。

### 3、Study on Multi-UAV Task clustering and Task Planning in Cooperative Reconnaissance

Zhao Junwei

https://ieeexplore.ieee.org/document/6911527

 

 

无人机任务分配：先进行任务聚类，再对每一类进行航迹规划，这里用的是TSP问题。

聚类用k-means ,聚类目标是使得每类目标的执行时间趋于平均。

### 5、分布式协同动态任务规划的建模与一体化求解方法

http://www.wanfangdata.com.cn/details/detail.do?_type=perio&id=zggxjsxb201704018

 

动态任务规划

模型：

![img](PaperNote.assets/clip_image004.png)

用**Dubins**路线当作路线长度。

算法没有讲清楚。模型可以参考一下。

### 6．多异构无人机任务规划 的分布式一体化求解方法

http://xueshu.baidu.com/usercenter/paper/show?paperid=190c08q0t9370440uh4x04d0et063627&site=xueshu_se

模型和上一篇差不多，算法讲清楚了。

### 7、动态环境中的无人机路径规划方法

http://www.wanfangdata.com.cn/details/detail.do?_type=perio&id=bjhkhtdxxb201402020

对于二维环境的动态障碍物用概率地图的方式来表示，模型可以参考。

### 8、基于作战模式驱动的巡航导弹协同作战任务规划研究

张明星

[链接](http://kns.cnki.net/KCMS/detail/detail.aspx?dbcode=CJFQ&dbname=CJFDLAST2018&filename=ZHKZ201801011&uid=WEEvREdxOWJmbC9oM1NjYkZCbDdrdXQyZVk2WlJaWndNdGhnWSt3cXhmTWI=$R1yZ0H6jyaa0en3RxVUd8df-oHi7XMMDo7mtKT6mSmEvTuk11l2gFA!!&v=MzI0NDBGckNVUkxPZlllZG5GeS9sVzd2T1B5WEFkTEc0SDluTXJvOUVaWVI4ZVgxTHV4WVM3RGgxVDNxVHJXTTE=)

对巡航导弹的协同模式比较清楚。

### 9.美国面向未来战争的导弹协同作战概念发展研究_赵鸿燕.

[链接](https://kns.cnki.net/KCMS/detail/detail.aspx?dbcode=CJFQ&dbname=CJFDTEMP&filename=HKBQ201904001&uid=WEEvREcwSlJHSldRa1FhcTdWa2FjR2F3UUxRd2RCUzlaVVFPMlJ0VmFHVT0=$9A4hF_YAuvQ5obgVAqNKPCYcEjKensW4IQMovwHtwkF4VYPoHbKxJw!!&v=MjgyNDBGckNVUkxPZVorZHZGeTNoVTd2TUxTYkpmN0c0SDlqTXE0OUZaWVI4ZVgxTHV4WVM3RGgxVDNxVHJXTTE=)

基本概念可以参考。导弹的任务规划概念，以及和其它相关研究的概念

### 10.基于改进PSO的多UAV协同任务分配研究

[link](https://kns.cnki.net/KCMS/detail/50.1213.TJ.20190920.1707.006.html?uid=WEEvREcwSlJHSldRa1FhdXNXaEhobmc4cTkrNjNTUzY2bGhCb3RsR0VQST0=$9A4hF_YAuvQ5obgVAqNKPCYcEjKensW4IQMovwHtwkF4VYPoHbKxJw!!&v=MDYwNDhUM2ZscVdNMENMTDdSN3FlYnVkdkZ5amxWYjdMSTFvPUpqalRaN0c0SDlqTXBvMUZaT3NPWXc5TXptUm42ajU3)

模型可以参考

### 11空战多目标分配的指派模型

[link](https://kns.cnki.net/KCMS/detail/detail.aspx?dbcode=CJFQ&dbname=CJFD2008&filename=HJHK200801018&uid=WEEvREcwSlJHSldRa1Fhb09jT0lPd1RPclBETnBDQXhtZFBLUnZRNW50dz0=$9A4hF_YAuvQ5obgVAqNKPCYcEjKensW4IQMovwHtwkF4VYPoHbKxJw!!&v=MTcwODZPZVorUnNGeS9uVTczTUxTZkRaYkc0SHRuTXJvOUViSVI4ZVgxTHV4WVM3RGgxVDNxVHJXTTFGckNVUkw=)

态势模型，目前采用

### 12反舰导弹协同任务规划系统研究

李红亮  [link]( https://kns.cnki.net/KCMS/detail/detail.aspx?dbcode=CJFQ&dbname=CJFD2012&filename=FHDD201209009&uid=WEEvREdxOWJmbC9oM1NjYkcyQzZ4Q2Z0ZEhsTGppL3dSL2ZyakRPOHlBWlg=$R1yZ0H6jyaa0en3RxVUd8df-oHi7XMMDo7mtKT6mSmEvTuk11l2gFA!!&v=MDQ3NDRhckc0SDlQTXBvOUZiWVI4ZVgxTHV4WVM3RGgxVDNxVHJXTTFGckNVUkxPZVorUm5GeURtVUx2TEl5WFA= )

预先规划，实时规划   概念和例子

### 13.基于遗传算法的舰载机对海导弹攻击任务分配模型研究

[link]( http://kns.cnki.net//KXReader/Detail?TIMESTAMP=637078877147601250&DBCODE=CJFQ&TABLEName=CJFD2012&FileName=JCKX201205029&RESULT=1&SIGN=LdcGX65XxtcDXl0qYHMFjIMW08A%3d )

模型可以参考

### 14. 目标大机动建模与空空导弹导引律设计 

[link]( https://kns.cnki.net/KCMS/detail/detail.aspx?dbcode=CMFD&dbname=CMFD201901&filename=1019800720.nh&uid=WEEvREcwSlJHSldRa1FhdkJkVG5heFhwejUyYmNkVDNmdW5YZzkxRzZnZz0=$9A4hF_YAuvQ5obgVAqNKPCYcEjKensW4IQMovwHtwkF4VYPoHbKxJw!!&v=MDg1NzNDamtWTC9KVkYyNkY3dTRIdGJPcjVFYlBJUjhlWDFMdXhZUzdEaDFUM3FUcldNMUZyQ1VSTE9lWitSbkY= )

硕士论文，可以参考载机规避导弹的机动形式 

### 15.基于AHP和遗传算法的导弹作战任务分配问题研究

[link]( https://kns.cnki.net/KCMS/detail/detail.aspx?dbcode=CJFQ&dbname=CJFDLAST2018&filename=JSSG201803008&uid=WEEvREcwSlJHSldRa1Fhb09jT0lPdmtobTVXWEsvVkJYYkdNTDNpbkE3bz0=$9A4hF_YAuvQ5obgVAqNKPCYcEjKensW4IQMovwHtwkF4VYPoHbKxJw!!&v=MDIyODBMejdZYWJHNEg5bk1ySTlGYklSOGVYMUx1eFlTN0RoMVQzcVRyV00xRnJDVVJMT2VadVpxRnkza1Vycko= )

对于导弹任务分配的概念可以参考

### 16. 空空导弹70年发展综述 

[link]( https://kns.cnki.net/KCMS/detail/detail.aspx?dbcode=CJFQ&dbname=CJFDLAST2016&filename=HKBQ201601001&uid=WEEvREdxOWJmbC9oM1NjYkZCbDdrNTBJK2c0WlZLVUljb2t5Y2Y4MVFJSjU=$R1yZ0H6jyaa0en3RxVUd8df-oHi7XMMDo7mtKT6mSmEvTuk11l2gFA!!&v=MTQwMTZyV00xRnJDVVJMT2VadVpwRkNubFY3L0FMU2JKZjdHNEg5Zk1ybzlGWllSOGVYMUx1eFlTN0RoMVQzcVQ= )

### 17.基于攻击区的空战指挥引导态势评估_游航航 

2019.03

这篇的空战态势更合理，准备用这个

### 18. 基于协同攻击区模型的多机最优攻击占位决策 

2018

对于多机协同的站位做了探讨，模型可以参考。

### 19.Research on Genetic Algorithm Theory and ItsApplication on Missile Fire Allocation

遗传算法理论研究及其在导弹火力分配中的应用

 https://ieeexplore.ieee.org/document/4594006 

GA 算法，导弹火力分配，模型是类似于指派，算法普通。

### 20.Improved genetic algorithm for multichannel ship-to-air missile weapon system WTA problem

多通道舰空导弹武器系统WTA问题的改进遗传算法

和上述文献模型一样，算法一样。

### 21.Research of cooperation guidance scheme based on multiple missiles engagement

基于多枚导弹交战的合作制导方案研究

### 22. Improved Particle Swarm Optimization Algorithm and its Application in Coordinated Air Combat Missile-Target Assignment 

粒子群算法，导弹任务分配，模型同上

### 23. 多导弹协同作战目标分配方法研究

[link]( https://kns.cnki.net/KCMS/detail/detail.aspx?dbcode=CJFQ&dbname=CJFDLAST2016&filename=FHDD201609019&uid=WEEvREcwSlJHSldRa1Fhb09jT0lPdmljaXBmRmFLSldReTgxU1Q1Slp4QT0=$9A4hF_YAuvQ5obgVAqNKPCYcEjKensW4ggI8Fm4gTkoUKaID8j8gFw!!&v=MDQ0OTJGeURsVWJyTUl5WFBhckc0SDlmTXBvOUViWVI4ZVgxTHV4WVM3RGgxVDNxVHJXTTFGckNVUkxPZVp1ZHI= )

研究现状，概念可参考

### 24. 改进合同网协议在防空武器目标分配中的应用 

[link]( https://kns.cnki.net/KCMS/detail/detail.aspx?dbcode=CJFQ&dbname=CJFDLAST2017&filename=XDFJ201704018&uid=WEEvREcwSlJHSldRa1Fhb09jT0lPdmljaXBmRVozTko0OWNhaFdPZE94MD0=$9A4hF_YAuvQ5obgVAqNKPCYcEjKensW4IQMovwHtwkF4VYPoHbKxJw!!&v=MzA4ODhadWRyRnlEblc3ek9QU25OWkxHNEg5Yk1xNDlFYklSOGVYMUx1eFlTN0RoMVQzcVRyV00xRnJDVVJMT2U= )

拍卖算法，wta问题



### 25. The Weapon-Target Assignment Problem

2018 这篇文章详细描述了各类WTA问题的数学形式和发展情况，具有较大的参考价值。

[link]( https://kns.cnki.net/KCMS/detail/detail.aspx?dbcode=SJES&dbname=SJESTEMP_U&filename=SJES2367333BAC72722E7D485D4806FA50F1&v=MDA3NzZEOE9SUmN5ZUNKVWFGMXVRVXIvUEpsY1NibUtDR1lDR1FsZkNwYlEwNTkxaXhMcTZ3cWs9TmlmT2ZiRzdHTmJQckl3M0ZaZ0lEbnM3eldNVW5qdDFUUXZtcEJJeg== )

### 26.Exact and heuristic methods for the vertex separator problem

顶点分割问题。数学方向论文。可以看一下证明过程，尤其是分支定界法部分。

### 27.Yukun Wang,Xuebo Chen. Hybrid quantum particle swarm optimization algorithm and its application[J]. ,2020,63(5).

量子粒子群算法

矩阵中0元素的定理:系数矩阵中独立0元素的最多个数等于能覆盖所有0元素的最少直线数。[link]( https://kns.cnki.net/KCMS/detail/detail.aspx?dbcode=CJFQ&dbname=CJFD2002&filename=HLYZ200204009&uid=WEEvREcwSlJHSldRa1Fhb09jT0lPdmlRM3VKMzVZQm9FaXQxVHZVc1VjTT0=$9A4hF_YAuvQ5obgVAqNKPCYcEjKensW4IQMovwHtwkF4VYPoHbKxJw!!&v=MDEzMDZPZVp1ZG5GeURuVzc3S0xTSFNkTEc0SHRQTXE0OUZiWVI4ZVgxTHV4WVM3RGgxVDNxVHJXTTFGckNVUkw= )

### 28."匈牙利法"存在的问题及改进方法

[link]( https://kns.cnki.net/KCMS/detail/detail.aspx?dbcode=CJFQ&dbname=CJFD2003&filename=WJFZ200304026&uid=WEEvREcwSlJHSldRa1Fhb09jT0lPdmlRM3VKMzVZQm9FaXQxVHZVc1VjTT0=$9A4hF_YAuvQ5obgVAqNKPCYcEjKensW4IQMovwHtwkF4VYPoHbKxJw!!&v=Mjk4NzdiL0FNaWZOZExHNEh0TE1xNDlIWW9SOGVYMUx1eFlTN0RoMVQzcVRyV00xRnJDVVJMT2VadWRuRnlEZ1U= )   

提到了匈牙利算法的问题

### 29. The Hungarian Method for the Assignment Problem

[link]( https://link.springer.com/chapter/10.1007/978-3-540-68279-0_2#citeas )

匈牙利算法原始版

### 30. A genetic programming hyper-heuristicapproach for the multi-skill resource constrained project scheduling problem

参考文献

### 32. Multi-target threat assessment in air combat based on AHP and FVIKOR

### 33. AIM-120空空导弹发展综述 

[link](  https://kns.cnki.net/KCMS/detail/detail.aspx?dbcode=CJFQ&dbname=CJFDLAST2015&filename=FHDD201503007&uid=WEEvREdxOWJmbC9oM1NjYkcyQzZ4Q1pIZGQyQkdldkVYN0dPSGIvcGN2Y2M=$R1yZ0H6jyaa0en3RxVUd8df-oHi7XMMDo7mtKT6mSmEvTuk11l2gFA!!&v=MDc5MDBGckNVUkxPZVp1UnVGeTdrVkw3UEl5WFBhckc0SDlUTXJJOUZZNFI4ZVgxTHV4WVM3RGgxVDNxVHJXTTE=  )

aim-120 参数来源

### 34 Larrañaga1999_Article_GeneticAlgorithmsForTheTravell.

路径编码TSP问题基本算子评价

[link]( https://link.springer.com/content/pdf/10.1023%2FA%3A1006529012972.pdf )

