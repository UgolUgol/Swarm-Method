#include <iostream>
#include <cmath>
#include <thrust>
#include "particle.h"

class Swarm
{
	
	const int objects_count;
	double global_opt;

	parameters pars;
thrust::host_vector<Particle> pat;

public:
	Swarm(int n);

	void updateOptimum(double p);

	~Swarm();
	
};



