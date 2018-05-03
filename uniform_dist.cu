#include "uniform_dist.h"

// ========= KERNELS ============== //

__global__ void initRandomizer(unsigned int seed, curandState* state){
	int idx = blockIdx.x * blockDim.x + threadIdx.x;
	curand_init(seed, idx, 0, &state[idx]);
}


// ================================ //

UniformDist::UniformDist(size_t count){
	cudaMalloc(&state, sizeof(curandState) * count * count);
	initRandomizer<<<count, count>>>(time(NULL), state);
}

__device__ vec2D UniformDist::generate(const int max, const int min, int idx){
	double x = curand_uniform(&state[idx]);
	double y = curand_uniform(&state[idx]);
	const int diff = max - min + fix;
	x = x * diff + min;
	y = y * diff + min;

	return vec2D(x, y);
}