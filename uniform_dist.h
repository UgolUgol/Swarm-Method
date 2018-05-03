#include <curand.h>
#include <curand_kernel.h>
#include "vec2D.h"




class UniformDist {
	curandState* state;
	const double fix = 0.999999;
public:
	UniformDist(size_t count);

	__device__ vec2D generate(const int max, const int min, int idx);
};