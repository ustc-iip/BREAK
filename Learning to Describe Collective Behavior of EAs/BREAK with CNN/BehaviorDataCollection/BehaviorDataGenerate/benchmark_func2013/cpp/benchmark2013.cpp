#include "Header.h"
#include "benchmark2013.h"
#include "mex.h"
#ifdef _WIN32
#include <Windows.h>
#else
#include <sys/time.h>
#include <cstdio>
#include <unistd.h>
#endif

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	//Òì³£´¦Àí
	if (nrhs != 2)
		mexErrMsgTxt("too few input values\n");
	if (!mxIsDouble(prhs[0]))
		mexErrMsgTxt("the Input Matrix must be double!\n");
	int func_num = mxGetScalar(prhs[1]);
	double *matrix = mxGetPr(prhs[0]);
	int D = mxGetM(prhs[0]);
	int NP = mxGetN(prhs[0]);
	plhs[0] = mxCreateDoubleMatrix((mwSize)NP, 1, mxREAL);
	double *outMatrix = mxGetPr(plhs[0]);
	//mexPrintf("NP = %d, D = %d func_num = %d\n", NP, D, func_num);
	benchmark_func(outMatrix, matrix, func_num, NP, D);
	//mexPrintf("outMatrix[0] = %lf", outMatrix[0]);
}

Benchmarks* generateFuncObj(int funcID);

void benchmark_func(double *f, double *x, int func_num, int NP, int D)
{
	Benchmarks *fp = generateFuncObj(func_num);
	int i = 0, j = 0;
	double *xForTest = new double[D];
	for (i = 0; i != NP; ++i)
	{
		for (j = 0; j != D; ++j)
		{
			xForTest[j] = x[i * D + j];
		}
		f[i] = fp->compute(xForTest);
	}
	delete[] xForTest;
	
}


// create new object of class with default setting
Benchmarks* generateFuncObj(int funcID){
  Benchmarks *fp;
  static F1 f1;
  static F2 f2;
  static F3 f3;
  static F4 f4;
  static F5 f5;
  static F6 f6;
  static F7 f7;
  static F8 f8;
  static F9 f9;
  static F10 f10;
  static F11 f11;
  static F12 f12;
  static F13 f13;
  static F14 f14;
  static F15 f15;
  if (funcID==1){
    fp = &f1;
  }else if (funcID==2){
    fp = &f2;
  }else if (funcID==3){
    fp = &f3;
  }else if (funcID==4){
    fp = &f4;
  }else if (funcID==5){
    fp = &f5;
  }else if (funcID==6){
    fp = &f6;
  }else if (funcID==7){
    fp = &f7;
  }else if (funcID==8){
    fp = &f8;
  }else if (funcID==9){
    fp = &f9;
  }else if (funcID==10){
    fp = &f10;
  }else if (funcID==11){
    fp = &f11;
  }else if (funcID==12){
    fp = &f12;
  }else if (funcID==13){
    fp = &f13;
  }else if (funcID==14){
    fp = &f14;
  }else if (funcID==15){
    fp = &f15;
  }else{
    cerr<<"Fail to locate Specified Function Index"<<endl;
    exit(-1);
  }
  return fp;
}
