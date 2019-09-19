# *coding=utf-8*
"""
计算态势矩阵
"""
import numpy as np
import math


class Situation:
    """
    态势信息类
            pm: 我方飞机位置,m*2数组，
            am: 我方飞机航向角m*1数组
            vm：我方飞机速度，m*1数组
            m_num: 我方飞机携带导弹数量，m*1数组
            pn: 敌方飞机位置
            an: 敌方飞机航向角
            vn: 敌方飞机速度
            n_priority: 敌方飞机优先级，需要用两枚导弹攻击
    demo:
         pm = np.array([[1, 2, 3], [1, 1, 1]], dtype=float)
         am = np.arange(0, 180, 60)   # 每隔60一个数字，0，60，120，区间[0,180)
         vm = np.ones([3, 1])*10
         m_num = np.array([1, 2, 1])
         pn = np.random.random([3, 2])*100
         an = np.arange(30, 200, 60)
         vn = np.ones([3, 1])*5
         priority = [1, 2, 1]
         Situation situ1(pm, am, vm, m_num, pn, an, vn, priority)

    """
    def __init__(self, pm, am, vm, m_num, pn, an, vn, priority):
        self.pm = pm
        self.am = am
        self.vm = vm
        self.m_num = m_num
        self.pn = pn
        self.an = an
        self.vn = vn
        self.priority = priority


class Model:

    """
    Model设定一些初始变量
    """
    dr_max = 1000  # 雷达最大搜索距离,单位km
    dm_max = 500  # 导弹最大攻击距离
    dm_min = 1   # 导弹最小攻击距离
    dmk_max = 300  # 最大不可逃逸区
    dmk_min = 100   # 最小不可逃逸区
    fai_r_max = 89   # 雷达搜索方位角
    fai_m_max = 85   #
    fai_mk_max = 50   #

    def __init__(self, dr_max=1000, dm_max=500, dm_min=1, dmk_max=300, dmk_min=100,
                 fai_r_max=89, fai_m_max=85, fai_mk_max=50):
        self.dr_max = dr_max
        self.dm_max = dm_max
        self.dm_min = dm_min
        self.dmk_max = dmk_max
        self.dmk_min = dmk_min
        self.fai_r_max = fai_r_max
        self.fai_m_max = fai_m_max
        self.fai_mk_max = fai_mk_max

    def get_matrix(self, situ: Situation):
        """
        in: Situation
        return:
              导弹序列：m_list,n'*1 [0,1,2,2,2,3,3]表示2号飞机有3枚导弹，m'*1
              目标序列：n_list，[ 0,1,2,3,3] 3号目标需要两枚导弹打击，priority>1的认为需要两枚导弹
              优势矩阵：matrix，m'*n'

        """
        num_plane = situ.am.shape[0]  #飞机数量
        num_target = situ.vn.shape[0]  #目标数量
        # 导弹序列
        m_list = []
        for i in range(num_plane):
            for j in range(situ.m_num[i]):
                m_list.append(i)
        #print(m_list)
        # 目标序列
        n_list = []
        for i in range(num_target):
            for j in range(situ.priority[i]):
                n_list.append(i)
        #print(n_list)
        # 计算距离矩阵
        d = np.zeros([num_plane, num_target])
        for i in range(num_plane):
            for j in range(num_target):
                d[i][j] = math.sqrt(
                    (situ.pm[i][0]-situ.pn[j][0])**2+(situ.pm[i][1]-situ.pn[j][1])**2
                )
        #print(d)

        # 计算距离优势fp
        fp = np.zeros([num_plane, num_target])  # 千万别写fp=d之类，是浅拷贝，会出问题。开辟新内存空间
        for i in range(num_plane):
            for j in range(num_target):
                fp[i][j] = self.get_fp(d[i][j])
        #print("fp", fp)
        # 速度优势
        fv = np.zeros([num_plane, num_target])
        for i in range(num_plane):
            for j in range(num_target):
                fv[i][j] = self.get_fv(situ.vm[i], situ.vn[j])
        #print("fv", fv)
        # 角度优势
        fa = np.zeros([num_plane, num_target])
        for i in range(num_plane):
            for j in range(num_target):
                fa[i][j] = self.get_fa(situ.am[i], situ.an[j], situ.pm[i, :], situ.pn[j, :])
        #print("fa", fa)


        # 总优势
        f_all = 1.0*fp+0.0*fv+0.0*fa
        #print("f_all", f_all)

        # 矩阵转换
        num_row = len(m_list)
        num_col = len(n_list)
        #print(num_row, num_col)
        matrix = np.zeros([num_row, num_col])
        for i in range(num_row):
            for j in range(num_col):
                matrix[i][j] = f_all[m_list[i]][n_list[j]]
        #print("matrix", matrix)
        return m_list, n_list, matrix

    def get_fp(self, d: float):
        """
        :param d: 距离
        :return: 距离优势
        """

        if d > self.dr_max or d < self.dm_min:
            fp = 0.0
        elif self.dm_max <= d < self.dr_max:
            fp = 0.5 * math.exp(-(d - self.dm_max) / (self.dr_max - self.dm_max))
        elif self.dmk_max <= d < self.dm_max:  # python3可以这样写
            fp = 2.0 ** (-(d - self.dmk_max) / (self.dm_max - self.dmk_max))
        elif self.dmk_min <= d < self.dmk_max:
            fp = 1.0
        elif self.dm_min <= d < self.dmk_min:
            fp = 2.0 ** ((d - self.dmk_min) / (self.dmk_min - self.dm_min))
        else:
            fp = 0.0
        return fp

    def get_fv(self, vm: float, vn: float):
        if vm > 1.5*vn:
            fv = 1.0
        elif 0.6*vn <= vm <= 1.5*vm:
            fv = -0.5+vm/vn
        else:
            fv = 0.1
        return fv

    def get_fa(self, am: float, an: float, pm, pn):
        """

        :param am: 飞机航向角   alpha: vector_a
        :param an: 敌方航向角   beta: vector_b
        :param pm: 飞机位置1*2 np数组  gama :vector_base
        :param pn: 敌方位置1*2数组
        :return:
        """
        # 转弧度计算向量
        vector_a = np.array([math.cos(am/360*2*math.pi), math.sin(am/360*2*math.pi)])
        vector_b = np.array([math.cos(an/360*2*math.pi), math.sin(an/360*2*math.pi)])
        vector_base = np.array((pn-pm)/np.linalg.norm(pn-pm, keepdims=True))  # 单位化
        # 相对方位角 alpha夹gama
        theta_a = math.acos(vector_a.dot(vector_base))/math.pi*180.0
        # 进入角
        theta_in = np.arccos(vector_b.dot(vector_base))/math.pi*180.0
        # 方位角优势
        if self.fai_m_max <= theta_a <= self.fai_r_max:
            fa = 0.3*(1-(theta_a-self.fai_m_max)/(self.fai_r_max-self.fai_m_max))
        elif self.fai_mk_max <= theta_a < self.fai_m_max:
            fa = 0.8-(theta_a-self.fai_mk_max)/2/(self.fai_m_max-self.fai_mk_max)
        elif 0 <= theta_a <= self.fai_mk_max:
            fa = 1-theta_a/5/self.fai_mk_max
        else:
            fa = 0.0
        # 进入角优势
        if theta_in < 50:
            fa1 = theta_in/50.0
        else:
            fa1 = 1-(theta_in-50)/130
        return 0.5*fa+0.5*fa1


class Model2:

        def get_matrix(self, situ: Situation):
            """
            in: Situation
            return:
                  导弹序列：m_list,n'*1 [0,1,2,2,2,3,3]表示2号飞机有3枚导弹，m'*1
                  目标序列：n_list，[ 0,1,2,3,3] 3号目标需要两枚导弹打击，priority>1的认为需要两枚导弹
                  距离矩阵：matrix，m'*n'

            """
            num_plane = situ.am.shape[0]  # 飞机数量
            num_target = situ.vn.shape[0]  # 目标数量
            # 导弹序列
            m_list = []
            for i in range(num_plane):
                for j in range(situ.m_num[i]):
                    m_list.append(i)
            # print(m_list)
            # 目标序列
            n_list = []
            for i in range(num_target):
                for j in range(situ.priority[i]):
                    n_list.append(i)
            # print(n_list)
            # 计算距离矩阵
            d = np.zeros([num_plane, num_target])
            for i in range(num_plane):
                for j in range(num_target):
                    d[i][j] = math.sqrt(
                        (situ.pm[i][0] - situ.pn[j][0]) ** 2 + (situ.pm[i][1] - situ.pn[j][1]) ** 2
                    )
            # 距离矩阵扩维
            num_row = len(m_list)
            num_col = len(n_list)
            # print(num_row, num_col)
            matrix = np.zeros([num_row, num_col])
            for i in range(num_row):
                for j in range(num_col):
                    matrix[i][j] = d[m_list[i]][n_list[j]]
            # print("matrix", matrix)
            return m_list, n_list, matrix





























