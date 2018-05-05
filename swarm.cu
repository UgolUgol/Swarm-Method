#include "swarm.h"
#include "kernels.h"
#include <iostream>
using namespace std;



Swarm::Swarm(int n, int argc, char** argv): objects_count(n), GlutWrapper(argc, argv, 1024, 648, "App"){
// change count to closest squad
	correctParticlesCount();
	device_objects.resize(objects_count);
	forces.resize(objects_count);

// create generator for speed/position
// we need two generators, one for start position and r1 parameter
// second for r2 parameter
	generator = new UniformDist(sq_count);
	help_generator = new UniformDist(sq_count);

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

vec2D Swarm::findMassCenter(){

// copy device to host
	host_objects = device_objects;

// mass center vector
	vec2D m = vec2D(0, 0);

// sum coordinates of particles
	for(int i = 0; i < objects_count; i++){
		m = m + host_objects[i].position;
	}

	return 1./(objects_count) * m;
}


void Swarm::correctParticlesCount(){

// this function change value to closest quad
// tnen we can use kernel as <quad, quad>
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
// find center of mass
	vec2D mc = findMassCenter();

// set camera position to center of mass
	setCamera(mc);
	cout<<mc;

// fill background
	background<<<dim3(32,32), dim3(8,32)>>>(data, w, h, xc, yc, sx, sy);
}

void Swarm::addPoints(uchar4* data){

// add points on display
	Particle* points = thrust::raw_pointer_cast(&device_objects[0]);
	drawParticles<<<sq_count, sq_count>>>(data, points, w, h, xc, yc, sx, sy);

}

void Swarm::regenPoints(){

// cast pointer on device object
	Particle* points = thrust::raw_pointer_cast(&device_objects[0]);
	UniformDist* dev_gen;
	UniformDist* dev_hgen;

// copy generators to gpu
	cudaMalloc(&dev_gen, sizeof(UniformDist));
	cudaMalloc(&dev_hgen, sizeof(UniformDist));
	cudaMemcpy(dev_gen, generator, sizeof(UniformDist), cudaMemcpyHostToDevice);
	cudaMemcpy(dev_hgen, help_generator, sizeof(UniformDist), cudaMemcpyHostToDevice);

// device ptr with global min convert to raw pointer
	vec2D* g = thrust::raw_pointer_cast(global_opt);

// calculate forces
	vec2D* fptr = thrust::raw_pointer_cast(&forces[0]);
	forceCalculate<<<sq_count, sq_count>>>(points, objects_count, fptr);

// calculate new position
	regenerate<<<sq_count, sq_count>>>(points, objects_count, fptr, dev_gen, dev_hgen, g, dt);

}

void Swarm::update() {

// start inits 
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

// unbind array
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

