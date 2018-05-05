#include <stdlib.h>
#include <cmath>

const double pi = 3.141592653;
const double e = 2.7182818284;
// ========== KERNELS ========================== //

__host__ __device__ double F(vec2D v) {
	return -20. * exp(-.2 * sqrt(.5 * (pow(v.x, 2) + pow(v.y, 2) ) ) ) - 
			exp(.5 * (cos(2 * 3.14 * v.x) + cos(2 * 3.14 * v.y))) + 2.71 + 20;
}

__global__ void generate_parameters(Particle* parts, int n, UniformDist* gen, vec2D* gptr){
	int idx = blockIdx.x * blockDim.x + threadIdx.x;
	int offsetx = blockDim.x * gridDim.x;
	const int max = 20;
	const int low = 10;
	vec2D g = gptr[0];

	for(int i = idx; i < n; i += offsetx){
		parts[i].position = gen->generate(low, max, idx);
		parts[i].speed = gen->generate(-(max - low), (max - low), idx);
		parts[i].init(parts[i].position);
		
		if(F(parts[i].local_opt) < F(g)) {
			gptr[0] = parts[i].local_opt;
		}
	}

}

__device__ double ptox(int i, int w){
	return 2.0 * i / (double)(w - 1) - 1.0;
}

__device__ double ptoy(int j, int h){
	return 2.0 * j / (double)(h - 1) - 1.0;
}

__device__ int xtop(double x, int w, double xc, double sx){
	return (((x / sx) + 1)) * (w - 1) / 2;
}

__device__ int ytop(double y, int h, double yc, double sy){
	return (((y / sy) + 1)) * (h - 1) / 2;
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
			vec2D v = vec2D(xc + sx*x, yc + sy*y);

			double f = F(v);
			cmap = color_map(f);
			data[j * w + i] = cmap;
		}
}


__device__ bool is_visible_point(int i, int j, int w, int h){
	return (i >= 0 && i < w && j >= 0 && j < h); 
}


__device__ void drawParticle(uchar4* data, int i, int j, int w, int h){
	
	// center
	data[j * w + i] = make_uchar4(0, 0, 0, 255);
	
	// up
	if(j + 1 < h)
		data[(j+1) * w + i] = make_uchar4(0, 0, 0, 255);
	
	// right
	if(i + 1 < w)
		data[j * w + (i+1)] = make_uchar4(0, 0, 0, 255);

	// down
	if(j - 1 >= 0)
		data[(j-1) * w + i] = make_uchar4(0, 0, 0, 255);

	// left
	if(i - 1 >= 0)
		data[j * w + (i-1)] = make_uchar4(0, 0, 0, 255);

}

__global__ void drawParticles(uchar4* data, Particle* pat, int w, int h,
						   double xc, double yc, 
						   double sx, double sy) {

	int idx = blockIdx.x * blockDim.x + threadIdx.x;
	int i = xtop(pat[idx].position.x, w, xc, sx);
	int j = ytop(pat[idx].position.y, h, yc, sy);
	
	if(is_visible_point(i, j, w, h)){
		drawParticle(data, i, j, w, h);
	}
}


__global__ void forceCalculate(Particle* pat, int n, vec2D* force){
	int i = blockIdx.x * blockDim.x + threadIdx.x;
	force[i] = vec2D(0, 0);


	for(int j = 0; j < n; j++){
		if(i != j){
			vec2D dist = pat[i].position - pat[j].position;
			force[i] = force[i] + 1./pow(dist.length(), 2) * dist;
		}
	}
}

__global__ void regenerate(Particle* pat, int n, vec2D* force, UniformDist* gen, UniformDist* hgen, vec2D* gptr, double dt){
	int idx = blockIdx.x * blockDim.x + threadIdx.x;
	double G = 1e-2;

	vec2D x = pat[idx].position;
	vec2D v = pat[idx].speed;
	vec2D p = pat[idx].local_opt;
	vec2D g = gptr[0];

// new position
	pat[idx].position = x + dt * (v + dt * G * force[idx]);

// check local optimum
	if(F(pat[idx].position) < F(p)){
		pat[idx].local_opt = pat[idx].position;
	}

// check global optimum
	if(F(pat[idx].local_opt) < F(g)) {
		gptr[0] = pat[idx].local_opt;
	}

// create random vector
	vec2D r1 = gen->generate(0, 1, idx);
	vec2D r2 = hgen->generate(0, 1, idx);

// calculate next speed
	pat[idx].speed = 0.99 * v + dt * ((0.5 * r1) * (p - x) + (0.7 * r2) * (g - x));

}
// ============================================= //



// =================== Comparators ============= // 

struct _cmp_xmax{
	__device__ bool operator()(Particle a, Particle b){
		return a.position.x > b.position.x;
	}
};

struct _cmp_ymax{
	__device__ bool operator()(Particle a, Particle b){
		return a.position.y > b.position.y;
	}
};

struct _cmp_xmin{
	__device__ bool operator()(Particle a, Particle b){
		return a.position.x < b.position.x;
	}
};

struct _cmp_ymin{
	__device__ bool operator()(Particle a, Particle b){
		return a.position.y < b.position.y;
	}
};

_cmp_xmax cmp_xmax;
_cmp_ymax cmp_ymax;
_cmp_xmin cmp_xmin;
_cmp_ymin cmp_ymin;

// ============================================== //