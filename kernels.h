#include <stdlib.h>

// ========== KERNELS ========================== //

__global__ void generate_parameters(Particle* parts, int n, UniformDist* gen){
	int idx = blockIdx.x * blockDim.x + threadIdx.x;
	int offsetx = blockDim.x * gridDim.x;
	const int max = 3;
	const int low = -3;

	for(int i = idx; i < n; i += offsetx){
		parts[i].position = gen->generate(low, max, idx);
		parts[i].speed = gen->generate(-(max - low), (max - low), idx);
		parts[i].init(parts[i].position);
	}
}


__host__ __device__ double F(double x, double y) {
	return -20. * exp(-.2 * sqrt(.5 * (pow(x, 2) + pow(y, 2) ) ) ) - 
			exp(.5 * (cos(2 * 3.14 * x) + cos(2 * 3.14 * y))) + 2.71 + 20;
}

__device__ double ptox(int i, int w){
	return 2.0 * i / (double)(w - 1) - 1.0;
}

__device__ double ptoy(int j, int h){
	return 2.0 * j / (double)(h - 1) - 1.0;
}

__device__ int xtop(double x, int w, double xc, double sx){
	return (((x / sx + xc) + 1)) * (w - 1) / 2;
}

__device__ int ytop(double y, int h, double yc, double sy){
	return (((y / sy + yc) + 1)) * (h - 1) / 2;
}

__device__ uchar4 color_map(double f){
	uchar4 cmap;
	if(f == 0.){
		cmap = make_uchar4(139, 0, 0, 255);
	}
	else if(f < 1){
		cmap = make_uchar4(178, 34, 34, 255);
	}
	else if(f < 2){
		cmap = make_uchar4(220, 20, 60, 255);
	}
	else if(f < 4){
		cmap = make_uchar4(255, 69, 0, 255);
	}
	else if(f < 5){
		cmap = make_uchar4(255, 99, 71, 255);
	}
	else if(f < 7){
		cmap = make_uchar4(255, 127, 80, 255);
	}
	else if(f < 9){
		cmap = make_uchar4(255, 160, 122, 255);
	}
	else {
		cmap = make_uchar4(255, 218, 185, 255);
	}

	return cmap;
}

__global__ void background(uchar4 *data, int w, int h,
					   double xc, double yc,
					   double sx, double sy) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;
	int idy = blockIdx.y * blockDim.y + threadIdx.y;
	int offsetx = blockDim.x * gridDim.x;
	int offsety = blockDim.y * gridDim.y;
	uchar4 cmap;

	for(int i = idx; i < w; i += offsetx)
		for(int j = idy; j < h; j += offsety) {
			double x = ptox(i, w);
			double y = ptoy(j, h);
			double f = F(xc + sx * x, yc + sy * y);
			cmap = color_map(f);
			data[j * w + i] = cmap;
		}
}


__device__ bool is_visible_point(int i, int j, int w, int h){
	return (i >= 0 && i < w && j >= 0 && j < h); 
}


__device__ void drawParticle(uchar4* data, int i, int j, int w){
	
	// center
	data[j * w + i] = make_uchar4(0, 0, 0, 255);
	
	// up
	data[(j+1) * w + i] = make_uchar4(0, 0, 0, 255);
	
	// right
	data[j * w + (i+1)] = make_uchar4(0, 0, 0, 255);

	// down
	data[(j-1) * w + i] = make_uchar4(0, 0, 0, 255);

	// left
	data[j * w + (i-1)] = make_uchar4(0, 0, 0, 255);

}

__global__ void drawParticles(uchar4* data, Particle* pat, int w, int h,
						   double xc, double yc, 
						   double sx, double sy) {

	int idx = blockIdx.x * blockDim.x + threadIdx.x;
	int i = xtop(pat[idx].position.x, w, xc, sx);
	int j = ytop(pat[idx].position.y, h, yc, sy);
	
	if(is_visible_point(i, j, w, h)){
		drawParticle(data, i, j, w);
	}
}

// ============================================= //