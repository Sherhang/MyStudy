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

#define CITY_SIZE 48 //城市数量

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

CITIES berlin52[CITY_SIZE] = {{6734.000000,1453.000000},{2233.000000,10.000000},{5530.000000,1424.000000},{401.000000,841.000000},{3082.000000,1644.000000},{7608.000000,4458.000000},{7573.000000,3716.000000},{7265.000000,1268.000000},{6898.000000,1885.000000},{1112.000000,2049.000000},{5468.000000,2606.000000},{5989.000000,2873.000000},{4706.000000,2674.000000},{4612.000000,2035.000000},{6347.000000,2683.000000},{6107.000000,669.000000},{7611.000000,5184.000000},{7462.000000,3590.000000},{7732.000000,4723.000000},{5900.000000,3561.000000},{4483.000000,3369.000000},{6101.000000,1110.000000},{5199.000000,2182.000000},{1633.000000,2809.000000},{4307.000000,2322.000000},{675.000000,1006.000000},{7555.000000,4819.000000},{7541.000000,3981.000000},{3177.000000,756.000000},{7352.000000,4506.000000},{7545.000000,2801.000000},{3245.000000,3305.000000},{6426.000000,3173.000000},{4608.000000,1198.000000},{23.000000,2216.000000},{7248.000000,3779.000000},{7762.000000,4595.000000},{7392.000000,2244.000000},{3484.000000,2829.000000},{6271.000000,2135.000000},{4985.000000,140.000000},{1916.000000,1569.000000},{7280.000000,4899.000000},{7509.000000,3239.000000},{10.000000,2676.000000},{6807.000000,2993.000000},{5185.000000,3258.000000},{3023.000000,1942.000000}};



int main()

{
    time_t start, end;
    double cost;
    time(&start);
    
	
    srand(1);

	int max_iterations = 6000;

	int max_no_improve = 50;

	//初始化指针数组

	Delta = new double *[CITY_SIZE];

	for (int i = 0; i < CITY_SIZE; i++)

		Delta[i] = new double[CITY_SIZE];

	SOLUTION best_solution;

	iterated_local_search(best_solution, berlin52, max_iterations, max_no_improve);

	cout << endl
		 << endl
		 << "搜索完成！最优路线总长度 = " << best_solution.cost << endl;

	cout << "最优访问城市序列如下：" << endl;

	for (int i = 0; i < CITY_SIZE; i++)

	{

		cout << setw(4) << setiosflags(ios::left) << best_solution.permutation[i];
	}
    time(&end);
    cost=difftime(end,start);
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
    file.open("opt_att48.txt"); //打开文件用于记录迭代过程，第一列是最优解，第二列是当前解，，分割

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