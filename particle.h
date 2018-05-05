#include <utility>
#include <iostream>
#include <random>
#include "uniform_dist.h"

using namespace std;

class Particle {
public:
	vec2D local_opt;
	vec2D position;
	vec2D speed;

	__host__ __device__ Particle();

	__host__ __device__ void init(vec2D opt);
	__host__ __device__ vec2D getLocalOptimum();
};

