#include <iostream>
#include <cmath>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/generate.h>
#include <thrust/sort.h>
#include <thrust/copy.h>
#include "particle.h"
#include "glutWrapper.h"

class Swarm : protected GlutWrapper{
	int objects_count;
	int sq_count;

	thrust::host_vector<Particle> host_objects;
	thrust::device_vector<Particle> device_objects;
	thrust::device_ptr<vec2D> global_opt;

protected:
	UniformDist* generator;
public:
	Swarm();
	Swarm(int n, int argc, char** argv);


	void run();
	void fillBackground(uchar4* data);
	void addPoints(uchar4* data);
	void regenPoints();

	void correctParticlesCount();
	void update();
	double F(vec2D vec);

	~Swarm();
	
};



