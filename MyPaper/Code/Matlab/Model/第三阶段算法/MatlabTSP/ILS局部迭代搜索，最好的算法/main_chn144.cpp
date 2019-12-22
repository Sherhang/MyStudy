////////////////////////

//TSP问题 迭代局部搜索求解代码

//基于chn144例子求解

//作者：infinitor

//修改：2940563940@qq.com

//修改时间：2019-12-21

////////////////////////

#include <iostream>
#include <cmath>
#include <stdlib.h>
#include <time.h>
#include <vector>
#include <windows.h>
#include <memory.h>
#include <string.h>
#include <iomanip>
#include <fstream>

#define DEBUG

using namespace std;

#define CITY_SIZE 144 //城市数量

//城市坐标
typedef struct candidate
{

	int x;

	int y;

} city, CITIES;

//优化值

double **Delta;

//解决方案

typedef struct Solution
{
	int permutation[CITY_SIZE]; //城市排列
	double cost;				//该排列对应的总路线长度
} SOLUTION;

// 计算邻域操作优化值
double calc_delta(int i, int k, int *tmp, CITIES *cities);
//计算两个城市间距离
double distance_2city(city c1, city c2);
//根据产生的城市序列，计算旅游总距离
double cost_total(int *cities_permutation, CITIES *cities);
//获取随机城市排列, 用于产生初始解
void random_permutation(int *cities_permutation);

//颠倒数组中下标begin到end的元素位置, 用于two_opt邻域动作

void swap_element(int *p, int begin, int end);

//邻域动作 反转index_i <-> index_j 间的元素

void two_opt_swap(int *cities_permutation, int *new_cities_permutation, int index_i, int index_j);

//本地局部搜索，边界条件 max_no_improve

void local_search(SOLUTION &best, CITIES *cities, int max_no_improve);

//判断接受准则

bool AcceptanceCriterion(int *cities_permutation, int *new_cities_permutation, CITIES *p_cities);

//将城市序列分成4块，然后按块重新打乱顺序。

//用于扰动函数

void double_bridge_move(int *cities_permutation, int *new_cities_permutation, CITIES *cities);

//扰动

void perturbation(CITIES *cities, SOLUTION &best_solution, SOLUTION &current_solution);

//迭代搜索

void iterated_local_search(SOLUTION &best, CITIES *cities, int max_iterations, int max_no_improve);

// 更新Delta

void Update(int i, int k, int *tmp, CITIES *cities);

//城市排列

int permutation[CITY_SIZE];

//城市坐标数组

CITIES cities[CITY_SIZE];

//berlin52城市坐标，最优解7542好像

CITIES berlin52[CITY_SIZE] = {{3639.000000,1315.000000},{4177.000000,2244.000000},{3569.000000,1438.000000},{3757.000000,1187.000000},{3904.000000,1289.000000},{3488.000000,1535.000000},{3506.000000,1221.000000},{3374.000000,1750.000000},{3237.000000,1764.000000},{3326.000000,1556.000000},{3089.000000,1251.000000},{3258.000000,911.000000},{3238.000000,1229.000000},{3646.000000,234.000000},{4172.000000,1125.000000},{4089.000000,1387.000000},{4020.000000,1142.000000},{4196.000000,1044.000000},{4095.000000,626.000000},{4312.000000,790.000000},{4403.000000,1022.000000},{4685.000000,830.000000},{4361.000000,73.000000},{4720.000000,557.000000},{4634.000000,654.000000},{4153.000000,426.000000},{2846.000000,1951.000000},{2831.000000,2099.000000},{3054.000000,1710.000000},{3086.000000,1516.000000},{2562.000000,1756.000000},{2716.000000,1924.000000},{2291.000000,1403.000000},{2751.000000,1559.000000},{2012.000000,1552.000000},{1779.000000,1626.000000},{682.000000,825.000000},{1478.000000,267.000000},{518.000000,1251.000000},{278.000000,890.000000},{1332.000000,695.000000},{3715.000000,1678.000000},{4016.000000,1715.000000},{4181.000000,1574.000000},{4087.000000,1546.000000},{3929.000000,1892.000000},{4062.000000,2220.000000},{3751.000000,1945.000000},{4061.000000,2370.000000},{4207.000000,2533.000000},{4201.000000,2397.000000},{4139.000000,2615.000000},{3777.000000,2095.000000},{3780.000000,2212.000000},{3888.000000,2261.000000},{3594.000000,2900.000000},{3678.000000,2463.000000},{3676.000000,2578.000000},{3789.000000,2620.000000},{4029.000000,2838.000000},{3862.000000,2839.000000},{3928.000000,3029.000000},{4263.000000,2931.000000},{4186.000000,3037.000000},{3492.000000,1901.000000},{3322.000000,1916.000000},{3479.000000,2198.000000},{3429.000000,1908.000000},{3318.000000,2408.000000},{3176.000000,2150.000000},{3296.000000,2217.000000},{3229.000000,2367.000000},{3394.000000,2643.000000},{3402.000000,2912.000000},{3101.000000,2721.000000},{3402.000000,2510.000000},{3792.000000,3156.000000},{3468.000000,3018.000000},{3142.000000,3421.000000},{3356.000000,3212.000000},{3130.000000,2973.000000},{3044.000000,3081.000000},{2765.000000,3321.000000},{3140.000000,3557.000000},{2545.000000,2357.000000},{2769.000000,2492.000000},{2611.000000,2275.000000},{2348.000000,2652.000000},{3712.000000,1399.000000},{3493.000000,1696.000000},{3791.000000,1339.000000},{3376.000000,1306.000000},{3188.000000,1881.000000},{3814.000000,261.000000},{3583.000000,864.000000},{4297.000000,1218.000000},{4116.000000,1187.000000},{4252.000000,882.000000},{4386.000000,570.000000},{4643.000000,404.000000},{4784.000000,279.000000},{3077.000000,1970.000000},{1828.000000,1210.000000},{2061.000000,1277.000000},{2788.000000,1491.000000},{2381.000000,1676.000000},{1777.000000,892.000000},{1064.000000,284.000000},{3688.000000,1818.000000},{3896.000000,1656.000000},{3918.000000,2179.000000},{3972.000000,2136.000000},{4029.000000,2498.000000},{3766.000000,2364.000000},{3896.000000,2443.000000},{3796.000000,2499.000000},{3478.000000,2705.000000},{3810.000000,2969.000000},{4167.000000,3206.000000},{3486.000000,1755.000000},{3334.000000,2107.000000},{3587.000000,2417.000000},{3507.000000,2376.000000},{3264.000000,2551.000000},{3360.000000,2792.000000},{3439.000000,3201.000000},{3526.000000,3263.000000},{3012.000000,3394.000000},{2935.000000,3240.000000},{3053.000000,3739.000000},{2284.000000,2803.000000},{2577.000000,2574.000000},{2860.000000,2862.000000},{2801.000000,2700.000000},{2370.000000,2975.000000},{1084.000000,2313.000000},{2778.000000,2826.000000},{2126.000000,2896.000000},{1890.000000,3033.000000},{3538.000000,3298.000000},{2592.000000,2820.000000},{2401.000000,3164.000000},{1304.000000,2312.000000},{3470.000000,3304.000000}};




int main()

{
    time_t start, end;
    double cost;
    time(&start);
    
	
    srand(1);

	int max_iterations = 2000;

	int max_no_improve = 50;

	//初始化指针数组

	Delta = new double *[CITY_SIZE];

	for (int i = 0; i < CITY_SIZE; i++)

		Delta[i] = new double[CITY_SIZE];

	SOLUTION best_solution;

	iterated_local_search(best_solution, berlin52, max_iterations, max_no_improve);

    ofstream file;
    file.open("opt_chn144.txt", ios::app); //打开文件用于记录迭代过程，第一列是最优解，第二列是当前解，，分割
	file << endl
		 << endl
		 << "搜索完成！最优路线总长度 = " << best_solution.cost << endl;
    cout << endl
		 << endl
		 << "搜索完成！最优路线总长度 = " << best_solution.cost << endl;
	file << "最优访问城市序列如下：" << endl;

	for (int i = 0; i < CITY_SIZE; i++)

	{

		file << setw(4) << setiosflags(ios::left) << best_solution.permutation[i];
	}
    time(&end);
    cost=difftime(end,start);
    file << "用时 " << cost << "秒" << endl;
    cout << "用时 " << cost << "秒" ;
	cout << endl
		 << endl;

	return 0;

}

//计算两个城市间距离

double distance_2city(city c1, city c2)

{

	double distance = 0;

	distance = sqrt((double)((c1.x - c2.x) * (c1.x - c2.x) + (c1.y - c2.y) * (c1.y - c2.y)));

	return distance;
}

//根据产生的城市序列，计算旅游总距离

//所谓城市序列，就是城市先后访问的顺序，比如可以先访问ABC，也可以先访问BAC等等

//访问顺序不同，那么总路线长度也是不同的

//p_perm 城市序列参数

double cost_total(int *cities_permutation, CITIES *cities)

{

	double total_distance = 0;

	int c1, c2;

	//逛一圈，看看最后的总距离是多少

	for (int i = 0; i < CITY_SIZE; i++)

	{

		c1 = cities_permutation[i];

		if (i == CITY_SIZE - 1) //最后一个城市和第一个城市计算距离

		{

			c2 = cities_permutation[0];
		}

		else

		{

			c2 = cities_permutation[i + 1];
		}

		total_distance += distance_2city(cities[c1], cities[c2]);
	}

	return total_distance;
}

//获取随机城市排列

void random_permutation(int *cities_permutation)

{

	int n = CITY_SIZE;

	int temp[CITY_SIZE];

	for (int i = 0; i < CITY_SIZE; i++)

		temp[i] = i;

	for (int i = 0; i < CITY_SIZE - 1; i++)

	{

		int r = rand() % n;

		cities_permutation[i] = temp[r];

		temp[r] = temp[n - 1];

		n--;
	}

	cities_permutation[CITY_SIZE - 1] = temp[0];
}

//颠倒数组中下标begin到end的元素位置

void swap_element(int *p, int begin, int end)

{

	int temp;

	while (begin < end)

	{

		temp = p[begin];

		p[begin] = p[end];

		p[end] = temp;

		begin++;

		end--;
	}
}

//邻域动作 反转index_i <-> index_j 间的元素

void two_opt_swap(int *cities_permutation, int *new_cities_permutation, int index_i, int index_j)

{

	for (int i = 0; i < CITY_SIZE; i++)

	{

		new_cities_permutation[i] = cities_permutation[i];
	}

	swap_element(new_cities_permutation, index_i, index_j);
}

double calc_delta(int i, int k, int *tmp, CITIES *cities)

{

	/*

	

                以下计算说明：

                对于每个方案，翻转以后没必要再次重新计算总距离

                只需要在翻转的头尾做个小小处理



                比如：

                有城市序列   1-2-3-4-5 总距离 = d12 + d23 + d34 + d45 + d51 = A

                翻转后的序列 1-4-3-2-5 总距离 = d14 + d43 + d32 + d25 + d51 = B

                由于 dij 与 dji是一样的，所以B也可以表示成 B = A - d12 - d45 + d14 + d25

                下面的优化就是基于这种原理

    */

	double delta = 0;

	if ((i == 0) && (k == CITY_SIZE - 1))

		delta = 0;

	else

	{

		int i2 = (i - 1 + CITY_SIZE) % CITY_SIZE;

		int k2 = (k + 1) % CITY_SIZE;

		delta = 0

				- distance_2city(cities[tmp[i2]], cities[tmp[i]])

				+ distance_2city(cities[tmp[i2]], cities[tmp[k]])

				- distance_2city(cities[tmp[k]], cities[tmp[k2]])

				+ distance_2city(cities[tmp[i]], cities[tmp[k2]]);
	}

	return delta;
}

/*

	去重处理，对于Delta数组来说，对于城市序列1-2-3-4-5-6-7-8-9-10，如果对3-5应用了邻域操作2-opt ， 事实上对于

	7-10之间的翻转是不需要重复计算的。所以用Delta提前预处理一下。

	

	当然由于这里的计算本身是O（1） 的，事实上并没有带来时间复杂度的减少（更新操作反而增加了复杂度） 

	如果delta计算 是O（n）的，这种去重操作效果是明显的。 

*/

void Update(int i, int k, int *tmp, CITIES *cities)
{

	if (i && k != CITY_SIZE - 1)
	{

		i--;
		k++;

		for (int j = i; j <= k; j++)
		{

			for (int l = j + 1; l < CITY_SIZE; l++)
			{

				Delta[j][l] = calc_delta(j, l, tmp, cities);
			}
		}

		for (int j = 0; j < k; j++)
		{

			for (int l = i; l <= k; l++)
			{

				if (j >= l)
					continue;

				Delta[j][l] = calc_delta(j, l, tmp, cities);
			}
		}

	} // 如果不是边界，更新(i-1, k + 1)之间的

	else
	{

		for (i = 0; i < CITY_SIZE - 1; i++)

		{

			for (k = i + 1; k < CITY_SIZE; k++)

			{

				Delta[i][k] = calc_delta(i, k, tmp, cities);
			}
		}

	} // 边界要特殊更新
}

//本地局部搜索，边界条件 max_no_improve

//best_solution最优解

//current_solution当前解

void local_search(SOLUTION &best_solution, CITIES *cities, int max_no_improve)

{

	int count = 0;

	int i, k;

	double inital_cost = best_solution.cost; //初始花费

	double now_cost = 0;

	SOLUTION *current_solution = new SOLUTION; //为了防止爆栈……直接new了，你懂的

	for (i = 0; i < CITY_SIZE - 1; i++)

	{

		for (k = i + 1; k < CITY_SIZE; k++)

		{

			Delta[i][k] = calc_delta(i, k, best_solution.permutation, cities);
		}
	}

	do

	{

		//枚举排列

		for (i = 0; i < CITY_SIZE - 1; i++)

		{

			for (k = i + 1; k < CITY_SIZE; k++)

			{

				//邻域动作

				two_opt_swap(best_solution.permutation, current_solution->permutation, i, k);

				now_cost = inital_cost + Delta[i][k];

				current_solution->cost = now_cost;

				if (current_solution->cost < best_solution.cost)

				{

					count = 0; //better cost found, so reset

					for (int j = 0; j < CITY_SIZE; j++)

					{

						best_solution.permutation[j] = current_solution->permutation[j];
					}

					best_solution.cost = current_solution->cost;

					inital_cost = best_solution.cost;

					Update(i, k, best_solution.permutation, cities);
				}
			}
		}

		count++;

	} while (count <= max_no_improve);
}

//判断接受准则

bool AcceptanceCriterion(int *cities_permutation, int *new_cities_permutation, CITIES *cities)

{

	int AcceptLimite = 500;

	int c1 = cost_total(cities_permutation, cities);

	int c2 = cost_total(new_cities_permutation, cities) - 500;

	if (c1 < c2)

		return false;

	else

		return true;
}

//将城市序列分成4块，然后按块重新打乱顺序。

//用于扰动函数

void double_bridge_move(int *cities_permutation, int *new_cities_permutation, CITIES *cities)

{

	/*对这一段函数，我们提出修改。因为实际上按原代码的方法并不能将

	 第一大块有效的扰动。同时，固定的扰动方法在第二次扰动后会大致恢

	 复原来的情形，只有少部分改变。我们提出一种将位置标签pos放入数组，

	 再进行随记排序来扰动的方案。同时去掉vector，这太傻了。

	 再补充一下，我认为除3比除4更好。

	 顺便修改了一下acceptance。*/

	int pos[5];

	pos[0] = 0;

	pos[1] = rand() % (CITY_SIZE / 3) + 1;

	pos[2] = rand() % (CITY_SIZE / 3) + CITY_SIZE / 3;

	pos[3] = rand() % (CITY_SIZE / 3) + (CITY_SIZE / 3) * 2;

	pos[4] = CITY_SIZE;

	int n = 4;

	int random_order[4], temp[4];

	for (int i = 0; i < 4; i++)

		temp[i] = i;

	for (int i = 0; i < 3; i++)

	{

		int r = rand() % n;

		random_order[i] = temp[r];

		temp[r] = temp[n - 1];

		n--;
	}

	random_order[3] = temp[0];

	int deadprotect = 0;

	do

	{

		int i = 0;

		for (int j = pos[random_order[0]]; j < pos[random_order[0] + 1]; j++)

		{

			new_cities_permutation[i] = cities_permutation[j];

			i++;
		}

		for (int j = pos[random_order[1]]; j < pos[random_order[1] + 1]; j++)

		{

			new_cities_permutation[i] = cities_permutation[j];

			i++;
		}

		for (int j = pos[random_order[2]]; j < pos[random_order[2] + 1]; j++)

		{

			new_cities_permutation[i] = cities_permutation[j];

			i++;
		}

		for (int j = pos[random_order[3]]; j < pos[random_order[3] + 1]; j++)

		{

			new_cities_permutation[i] = cities_permutation[j];

			i++;
		}

		deadprotect++;

		//cout<<deadprotect;

		//cout<<endl;

		if (deadprotect == 5)
			break;

	} while (AcceptanceCriterion(cities_permutation, new_cities_permutation, cities));
}

//扰动

void perturbation(CITIES *cities, SOLUTION &best_solution, SOLUTION &current_solution)

{

	double_bridge_move(best_solution.permutation, current_solution.permutation, berlin52);

	current_solution.cost = cost_total(current_solution.permutation, cities);
}

//迭代搜索

//max_iterations用于迭代搜索次数

//max_no_improve用于局部搜索边界条件

void iterated_local_search(SOLUTION &best_solution, CITIES *cities, int max_iterations, int max_no_improve)

{
    ofstream file;
    file.open("opt_chn144.txt"); //打开文件用于记录迭代过程，第一列是最优解，第二列是当前解，，分割

	SOLUTION *current_solution = new SOLUTION;

	//获得初始随机解

	random_permutation(best_solution.permutation);

	best_solution.cost = cost_total(best_solution.permutation, cities);

	local_search(best_solution, cities, max_no_improve); //初始搜索

	for (int i = 0; i < max_iterations; i++)

	{

		perturbation(cities, best_solution, *current_solution); //扰动+判断是否接受新解

		local_search(*current_solution, cities, max_no_improve); //继续局部搜索

		//找到更优解

		if (current_solution->cost < best_solution.cost)

		{

			for (int j = 0; j < CITY_SIZE; j++)

			{

				best_solution.permutation[j] = current_solution->permutation[j];
			}

			best_solution.cost = current_solution->cost;
		}
        
        file << best_solution.cost << ',' << current_solution->cost << endl; //记录搜索过程

		// cout << setw(13) << setiosflags(ios::left) << "迭代搜索 " << i << " 次\t"
		// 	 << "最优解 = " << best_solution.cost << " 当前解 = " << current_solution->cost << endl;
	}
    file.close();
}