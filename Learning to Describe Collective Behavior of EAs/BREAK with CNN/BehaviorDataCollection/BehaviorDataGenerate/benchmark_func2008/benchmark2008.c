// benchmark2008.cpp : 定义 DLL 应用程序的导出函数。
//


#include "benchmark2008.h"
#include "data.h"
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

BENCHMARK2008_API void Shifted_Sphere(double *f, double* x, int n, int dim) {
	int i, j;
	double z;
	for (j = 0; j != n; ++j)
	{
		f[j] = 0;
		for (i = 0;i < dim;i++) {
			z = x[j * dim + i] - sphere[i];
			f[j] += z * z;
		}
	}
}

BENCHMARK2008_API void Schwefel_Problem(double *f, double* x, int n, int dim) {
	int i, j;
	double z;
	for (j = 0; j != n; ++j)
	{
		f[j] = abss(x[j * dim] - schwefel[0]);
		for (i = 1;i < dim;i++) {
			z = x[j * dim + i] - schwefel[i];
			f[j] = max(f[j], abss(z));
		}
	}
}

BENCHMARK2008_API void Shifted_Rosenbrock(double *f, double* x, int n, int dim) {
	int i, j;
	double *z = (double*)malloc(dim*sizeof(double));
	for (j = 0; j != n; ++j)
	{
		f[j] = 0;
		for (i = 0;i < dim;i++) z[i] = x[j * dim + i] - rosenbrock[i] + 1;

		for (i = 0;i < dim - 1;i++) {
			f[j] = f[j] + 100 * (pow((pow(z[i], 2) - z[i + 1]), 2)) + pow((z[i] - 1), 2);
		}
	}
	free(z);
}


BENCHMARK2008_API void Shifted_Rastrigin(double *f, double* x, int n, int dim)
{
	int i, j;
	double z;
	for (j = 0; j != n; ++j)
	{
		f[j] = 0;
		double pi = acos(-1.0);
		for (i = 0;i < dim;i++) {
			z = x[j * dim + i] - rastrigin[i];
			f[j] = f[j] + (pow(z, 2) - 10 * cos(2 * pi*z) + 10);
		}
	}
}

BENCHMARK2008_API void Shifted_Griewank(double *f, double* x, int n, int dim) {
	int i, j;
	double z;
	for (j = 0; j != n; ++j)
	{
		double f1 = 0;
		double f2 = 1;
		f[j] = 0;
		for (i = 0;i < dim;i++) {
			z = x[j * dim + i] - griewank[i];
			f1 = f1 + (pow(z, 2) / 4000);
			f2 = f2 * (cos(z / sqrt(i + 1)));

		}
		f[j] = f1 - f2 + 1;
	}
}

BENCHMARK2008_API void Shifted_Ackley(double *f, double* x, int n, int dim) {
	int i, j;
	double z;
	double e = exp(1);
	double pi = acos(-1.0);
	for (j = 0; j != n; ++j)
	{
		double Sum1 = 0;
		double Sum2 = 0;
		f[j] = 0;
		for (i = 0;i < dim;i++) {
			z = x[j * dim + i] - ackley[i];
			Sum1 = Sum1 + pow(z, 2);
			Sum2 = Sum2 + cos(2 * pi*z);
		}

		f[j] = -20 * exp(-0.2*sqrt(Sum1 / dim)) - exp(Sum2 / dim) + 20 + e;
	}
}
