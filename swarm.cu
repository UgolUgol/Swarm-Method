#include "swarm.h"
#include "kernels.h"
#include <iostream>
using namespace std;



Swarm::Swarm(int n, int argc, char** argv): objects_count(n), GlutWrapper(argc, argv, 1024, 648, "App") {
	// change count to closest squad
	correctParticlesCount();

	device_objects.resize(objects_count);
	generator = new UniformDist(sq_count);

	Particle* data = thrust::raw_pointer_cast(&device_objects[0]);
	UniformDist* dev_gen;

	cudaMalloc(&dev_gen, sizeof(UniformDist));
	cudaMemcpy(dev_gen, generator, sizeof(UniformDist), cudaMemcpyHostToDevice);
	generate_parameters<<<sq_count, sq_count>>>(data, objects_count, dev_gen);

	host_objects = device_objects;
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

void Swarm::update() {
	static double t = 0.0;
	uchar4 *data;
	size_t size;
	buffer->mapResource();
	buffer->mappedPointer(&data, size);


// draw function contour
	background<<<dim3(32,32), dim3(8,32)>>>(data, w, h, xc, yc, sx, sy);

// add points to display
	Particle* points = thrust::raw_pointer_cast(&device_objects[0]);
	drawParticles<<<sq_count, sq_count>>>(data, points, w, h, xc, yc, sx, sy);

// next step 


	CSC(cudaGetLastError());
	buffer->unmapResource();

	t += 0.05;
	glutPostRedisplay();
}

void Swarm::updateOptimum(vec2D p){
	if(F(p) < F(global_opt)){
		global_opt = p;
	}
}


double Swarm::F(vec2D vec){
	return -20. * exp(-.2 * sqrt(.5 * (pow(vec.x, 2) + pow(vec.y, 2) ) ) ) - 
			exp(.5 * (cos(2 * pi * vec.x) + cos(2 * pi * vec.y))) + e + 20;
}


Swarm::~Swarm(){

}

