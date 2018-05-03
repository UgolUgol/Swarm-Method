#include <iostream>
#include <cmath>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/generate.h>
#include <thrust/sort.h>
#include <thrust/copy.h>
#include "particle.h"
#include "glutWrapper.h"

const double pi = 3.141592653;
const double e = 2.7182818284;

class Swarm : protected GlutWrapper{
	int objects_count;
	int sq_count;
	vec2D global_opt;

	parameters pars;
	thrust::host_vector<Particle> host_objects;
	thrust::device_vector<Particle> device_objects;
protected:
	UniformDist* generator;
public:
	Swarm();
	Swarm(int n, int argc, char** argv);


	void run();
	void updateOptimum(vec2D p);
	void correctParticlesCount();
	void update();
	double F(vec2D vec);

	~Swarm();
	
};



