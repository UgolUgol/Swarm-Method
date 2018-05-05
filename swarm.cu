#include "swarm.h"
#include "kernels.h"
#include <iostream>
using namespace std;



Swarm::Swarm(int n, int argc, char** argv): objects_count(n), GlutWrapper(argc, argv, 1024, 648, "App") {
// change count to closest squad
	correctParticlesCount();
	device_objects.resize(objects_count);
	forces.resize(objects_count);

// create generator for speed/position
	generator = new UniformDist(sq_count);

// create global optimum start value equal to 20(max val of my function in lim)
	global_opt = thrust::device_malloc<vec2D>(1);
	global_opt[0] = vec2D(5, 5);
	vec2D* g = thrust::raw_pointer_cast(global_opt);

// create device object ptr and generator on device
	Particle* data = thrust::raw_pointer_cast(&device_objects[0]);
	UniformDist* dev_gen;

// generate parameters
	cudaMalloc(&dev_gen, sizeof(UniformDist));
	cudaMemcpy(dev_gen, generator, sizeof(UniformDist), cudaMemcpyHostToDevice);
	generate_parameters<<<sq_count, sq_count>>>(data, objects_count, dev_gen, g);

}

void Swarm::correctParticlesCount(){
	sq_count = sqrt(objects_count);

	if(sq_count * sq_count < objects_count){
		sq_count++;
	}
	objects_count = sq_count * sq_count;
}

void Swarm::run(){
	renderCycle();
}

void Swarm::fillBackground(uchar4* data) {
	background<<<dim3(32,32), dim3(8,32)>>>(data, w, h, xc, yc, sx, sy);
}

void Swarm::addPoints(uchar4* data){
	Particle* points = thrust::raw_pointer_cast(&device_objects[0]);
	drawParticles<<<sq_count, sq_count>>>(data, points, w, h, xc, yc, sx, sy);
}

void Swarm::regenPoints(){
	Particle* points = thrust::raw_pointer_cast(&device_objects[0]);
	UniformDist* dev_gen;

// copy generator to gpu
	cudaMalloc(&dev_gen, sizeof(UniformDist));
	cudaMemcpy(dev_gen, generator, sizeof(UniformDist), cudaMemcpyHostToDevice);

// device ptr with global min convert to raw pointer
	vec2D* g = thrust::raw_pointer_cast(global_opt);

// calculate forces
	vec2D* fptr = thrust::raw_pointer_cast(&forces[0]);
	forceCalculate<<<sq_count, sq_count>>>(points, objects_count, fptr);

// calculate new position
	regenerate<<<sq_count, sq_count>>>(points, objects_count, fptr, dev_gen, g, dt);

}

void Swarm::update() {
	static double t = 0.0;
	uchar4 *data;
	size_t size;
	buffer->mapResource();
	buffer->mappedPointer(&data, size);

// draw function contour
	fillBackground(data);

// add points to display
	addPoints(data);

// next step
	regenPoints();


	CSC(cudaGetLastError());
	buffer->unmapResource();

	t += dt;
	glutPostRedisplay();
}

double Swarm::F(vec2D vec){
	return -20. * exp(-.2 * sqrt(.5 * (pow(vec.x, 2) + pow(vec.y, 2) ) ) ) - 
			exp(.5 * (cos(2 * pi * vec.x) + cos(2 * pi * vec.y))) + e + 20;
}


Swarm::~Swarm(){

}

