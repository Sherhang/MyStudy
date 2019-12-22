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

#define CITY_SIZE 535 //城市数量

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

CITIES berlin52[CITY_SIZE] = {{3649,749},{5706,951},{3022,4814},{515,-356},{3.459000e+03,-10637},{5712,-212},{1645,-9945},{536,-10},{2856,-1336},{859,3.848000e+03},{1250,4502},{-3.448000e+03,13838},{3023,-933},{5618,1251},{3640,-430},{4.038000e+03,817},{3511,-350},{4155,848},{-3701,17447},{3817,-34},{3642,313},{3611,3714},{3514,-10142},{3158,3.559000e+03},{5218,446},{6110,-14959},{3957,3.241000e+03},{5111,428},{1.708000e+03,-6147},{4337,1322},{2938,3501},{5939,1755},{1518,3.855000e+03},{-2514,-5731},{2358,3247},{3754,2344},{3346,-8431},{1230,-7.001000e+03},{2426,5428},{3.655000e+03,3048},{2616,5038},{4029,5001},{3911,-7.640000e+03},{1048,-7452},{-1611,-5230},{1025,4501},{4118,2.050000e+02},{3222,-6442},{4156,-7241},{4039,1757},
{4449,2.019000e+03},{9.210000e+02,3431},{3206,2016},{5229,1324},{4827,-425},{-1948,345},{3349,3529},{5439,-614},{3.548000e+03,-10122},{424,1.831000e+03},{1304,-5930},{6017,513},{4448,-6850},{3314,4414},{4540,924},{3.334000e+03,-8645},{5227,-145},{4233,9.290000e+02},{4548,-10837},{4328,-132},{1321,-1.640000e+03},{-319,2919},{1355,10036},{1238,-802},{5544,909},{4432,1118},{1257,7.740000e+03},{-1541,3458},{2713,5622},{-2725,1.530500e+04},{4450,-43},{442,-7409},{5047,-151},{1905,7252},{6716,1422},{4222,-7100},{5303,848},{4108,1647},{4655,730},{5131,-235},{5054,429},{-1552,-4755},{4735,732},{4810,1613},{4727,1.915000e+03},{-3449,-5832},{4255,-7838},{4430,2606},{4927,2.070000e+02},{-4.150000e+02,1515},
{3915,9.040000e+02},{3008,3124},{2311,11316},{3333,-740},{-1154,2245},{449,-5222},{5213,11},{-3519,14912},{1036,-6659},{2239,8827},{5250,-119},{4901,233},{4333,657},{4540,-19},{3.937000e+03,1955},{5052,709},{4159,-8754},{4148,1236},{934,-1337},{4125,-8.151000e+03},{326,-7625},{4231,848},{-2802,14537},{711,7953},{4004,-8304},{3322,-735},{4807,722},{4422,2829},{4540,-19},{621,223},{5537,1239},{-3358,1836},{3728,1504},{1027,-7531},{-2625,1.461400e+04},{3900,1705},{1212,-6.857000e+03},{3.909000e+03,-8420},{3903,-8420},{5124,-312},{2911,-8103},{2346,9023},{1445,4259},{3250,-9651},{3325,3631},{-653,3.912000e+03},{4234,1816},{-2958,3057},{3851,-7702},{2834,7.707000e+03},
{3946,-10453},{3246,-9624},{2616,5010},{4716,505},{3.352000e+03,1047},{1445,-1730},{401,943},{1.908000e+03,3026},{2516,5134},{4922,10},{-8.450000e+02,11510},{5108,1346},{-1225,1.305200e+04},{4214,-8332},{4213,-8321},{5326,-615},{5117,645},{2515,5520},{3,3226},{4532,418},{5557,-322},{5127,523},{3148,-10616},{5250,-119},{4819,604},{4007,3300},{4.009000e+03,8240},{4042,-7.410000e+03},{5044,-325},{-3449,-5832},{6.449000e+03,-14751},{3701,-758},{-1135,2731},{5954,1037},{4149,1215},{1435,-6100},{3356,4580},{-4.230000e+02,1526},{4349,1112},{8.370000e+02,-1312},{4126,1532},{5002,834},{4412,1204},{-2113,2729},{2827,-1352},{5329,-100},{-1927,2952},{5423,1828},{6012,1105},{2457,1010},
{-2250,-4315},{5552,-426},{4522,520},{709,4143},{4425,850},{5740,1818},{4154,246},{3711,-347},{4700,1526},{5109,-11},{1434,-9032},{4614,607},{-209,-7953},{5228,942},{5338,1000},{6019,2458},{3.520000e+03,2511},{3020,12051},{2219,11412},{3140,609},{3533,13946},{2120,-1.575500e+04},{2959,-9528},{3857,-7727},{4306,-7.857000e+03},{3.852000e+03,122},{4734,-9727},{5021,3055},{-2544,-5428},{3944,-8617},{4.059000e+03,2849},{3817,2710},{2130,3.912000e+03},{4913,-212},{4.038000e+03,-7.346000e+03},{1133,4310},{-609,10651},{-2608,2815},{-322,3.638000e+03},{4528,-7344},{1203,831},{3.434000e+03,6912},{6359,-2237},{-158,3008},{2234,12017},{2454,6709},{-618,15543},{1.756000e+03,-7648},{5005,1947},{1536,3233},
{2742,8522},{308,10133},{2913,4758},{-851,1314},{1036,-6659},{3604,-11509},{3356,-11824},{5352,-139},{4858,227},{27,925},{3.452000e+03,3.338000e+03},{4311,0},{5949,3017},{3651,-2.220000e+02},{5124,1225},{5125,1214},{610,1.150000e+02},{4046,-7352},{3357,-11824},{5038,527},{5109,-11},{5128,-27},{5034,305},{-1201,-7.707000e+03},{4527,916},{3846,-908},{4613,1428},{3.530000e+03,1237},{4814,1411},{5128,-27},{635,320},{2756,-1523},{-1630,-6811},{5321,-2.530000e+02},{610,1.150000e+02},{5153,-22},{-2555,3.234000e+03},{-1520,2827},{4.270000e+02,11400},{4937,612},{-1.749000e+03,2549},{2541,3243},{4544,4.560000e+02},{1300,8011},{4029,-334},{3152,-413},{5321,-216},{-304,-6000},{1034,-7144},{-4.020000e+02,3936},
{4622,1547},{3918,-9444},{2832,-8120},{2336,5817},{4425,850},{-3744,14454},{2431,3942},{-3.741000e+03,14451},{1.926000e+03,-9904},{1207,-8611},{2.010000e+02,4519},{2548,-8017},{2056,-8941},{4527,916},{3.545000e+03,1045},{3907,-9436},{3.552000e+03,1429},{4.110000e+02,7.332000e+03},{4745,726},{5533,1322},{5431,-125},{1431,12101},{5558,3725},{4335,358},{-2555,3.234000e+03},{-858,12513},{4326,513},{-2.026000e+03,5741},{5121,121},{4453,-9313},{5352,2733},{5055,547},{2959,-9016},{-2631,3119},{4808,1142},{-3450,-5602},{4538,843},{4905,608},{-1745,17727},{4053,1418},{2502,-7728},{-119,3656},{4340,713},{5502,-141},{4556,606},{1208,1502},{3256,12956},{3.509000e+03,3617},{1329,210},{1.806000e+03,-1557},
{-1300,2839},{5835,1.615000e+03},{3.545000e+03,1.402300e+04},{4709,-136},{4930,1105},{5241,117},{4.038000e+03,-7.346000e+03},{5528,1.020000e+03},{4626,3041},{2621,12746},{3526,-9746},{4054,931},{4107,-9555},{4114,-841},{4159,-8754},{5150,-8.290000e+02},{2826,-8119},{3.538000e+03,-37},{4843,223},{3447,1.352700e+04},{6012,1105},{5112,252},{4434,2606},{1221,-131},{4326,-550},{1834,-7217},{4843,223},{4.005000e+03,11636},{-3156,11558},{4.520000e+02,702},{3708,-7630},{3.952000e+03,-7.515000e+03},{3326,-11201},{5552,-426},{4635,18},{4.030000e+03,-8014},{-515,3949},{3933,244},{3810,1306},{1133,10451},{3649,1158},{-927,14713},{1036,-6121},{9.050000e+02,-7923},{5006,1416},{4341,1024},{4226,1411},{1616,-6132},{9.030000e+02,-7.924000e+03},{4323,-25},
{4539,1212},{3137,-8.030000e+02},{3403,-645},{-808,-3.455000e+03},{3804,1539},{6408,-2157},{1654,9609},{4919,403},{3.623000e+03,2807},{-2943,-5342},{-2250,-4315},{4513,1435},{4401,1237},{4804,-144},{614,-1.022000e+03},{4149,1215},{1410,14515},{-3.255000e+03,-6047},{5157,426},{2442,4644},{3.337000e+03,7306},{630,-5815},{1529,4413},{1342,-8907},{3244,-11711},{-2300,-4708},{2932,-9828},{-1.756000e+03,3106},{4831,-2480},{-3.323000e+03,-7047},{4254,-825},{3314,4414},{1.826000e+03,-6.940000e+03},{4727,-12218},{2700,1427},{3733,12648},{5134,42},{-4.400000e+02,5531},{3.737000e+03,-12223},{3112,12120},{2521,5524},{1645,-2257},{121,10354},{3722,-12156},{4349,1820},{958,-8416},{959,-8412},{1.826000e+03,-6.601000e+03},{4031,2258},{4158,2138},
{4053,-11157},{3658,-2510},{5242,-8.550000e+02},{4242,2324},{4332,1618},{-1254,-3.820000e+03},{3.845000e+03,-9022},{5133,1.400000e+01},{5939,1755},{4841,9.130000e+02},{3854,1.615000e+03},{5853,538},{5558,3725},{3726,-554},{4832,738},{5222,1330},{-3356,15110},{2933,5236},{4748,1300},{4031,1.724000e+03},{4119,6.924000e+03},{2829,-1620},{3831,-2843},{4311,0},{2829,-1620},{1402,-8714},{5229,1324},{3.541000e+03,5119},{4120,1947},{3240,1309},{4337,123},{3201,3453},{2249,527},{23,643},{3543,-555},{-1848,4729},{3356,806},{-2442,-5342},{2504,12133},{3.755000e+03,1229},{5123,-2.430000e+02},{4512,739},{4550,1328},{4539,1212},{4726,43},{3618,-9552},{3651,1014},{5234,1318},{3533,13946},{3554,-8353},
{4.062000e+03,1311},{-8,-7.829000e+03},{1241,10101},{1345,-6057},{4455,458},{4314,2749},{4530,1221},{-2300,-4708},{4807,1.633000e+03},{3929,-2.900000e+01},{4142,-451},{4524,1053},{3857,-7727},{5210,2058},{3.645000e+03,-604},{5319,-11335},{4453,-6331},{4541,-7402},{4519,-7.540000e+03},{4648,-7.124000e+03},{4216,-8258},{4857,-5434},{4528,-7344},{4911,-12310},{4955,-9714},{5107,-11401},{4737,-5245},{4341,-7938},{4406,1521},{4545,1604},{4140,-103},{-613,3.913000e+03},{4728,833},{5133,1.400000e+01},{2458.000000,9153.000000}};

int main()

{
    time_t start, end;
    double cost;
    time(&start);
    
	
    srand(1);

	int max_iterations = 1000;

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
    file.open("opt_ali535.txt"); //打开文件用于记录迭代过程，第一列是最优解，第二列是当前解，，分割

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

		cout << setw(13) << setiosflags(ios::left) << "迭代搜索 " << i << " 次\t"
			 << "最优解 = " << best_solution.cost << " 当前解 = " << current_solution->cost << endl;
	}
    file.close();
}