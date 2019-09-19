#include "mex.h"
double my_add(double x, double y)
{
return x + y;
}
 
/*
*	nlhs 输出参数数目
*	plhs 指向输出参数的指针
*	nrhs 输入参数数目
*/
void mexFunction(int nlhs,mxArray *plhs[], int nrhs,const mxArray *prhs[])

{
    double *a;
    double b, c;
    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    a = mxGetPr(plhs[0]);
    b = *(mxGetPr(prhs[0]));
    c = *(mxGetPr(prhs[1]));
    *a = my_add(b, c);
}