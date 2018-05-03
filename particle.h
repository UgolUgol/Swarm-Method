#include <utility>
#include <iostream>
#include <random>
#include "uniform_dist.h"

using namespace std;

struct parameters{
	double a;
	double b;
	double w;
};


class Particle
{
	vec2D local_opt;
public:
	vec2D position;
	vec2D speed;
	__host__ __device__ Particle();

	__host__ __device__ void init(vec2D opt);
	vec2D getLocalOptimum();
};

