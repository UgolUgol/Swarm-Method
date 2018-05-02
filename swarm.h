#include <iostream>
#include <cmath>
#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/generate.h>
#include <thrust/sort.h>
#include <thrust/copy.h>
#include "particle.h"

const double pi = 3.141592653;
const double e = 2.7182818284;

class Swarm
{
	const int objects_count;
	vec2D global_opt;

	parameters pars;
	thrust::host_vector<Particle> objects;

protected:
	UniformDist* generator;
public:
	Swarm();
	Swarm(int n);

	void updateOptimum(vec2D p);
	double F(vec2D vec);

	~Swarm();
	
};



