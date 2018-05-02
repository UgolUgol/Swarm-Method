#include "swarm.h"
#include <iostream>
using namespace std;

Swarm::Swarm(int n): objects_count(n){
	objects.resize(objects_count);
	generator = new UniformDist(-5., 5.);

	for(auto obj = objects.begin(); obj != objects.end(); obj++){
		*obj = Particle();
		vec2D p = (*obj).getLocalOptimum();
		updateOptimum(p);
	}
}


void Swarm::updateOptimum(vec2D p){
	if(F(p) < F(global_opt)){
		global_opt = p;
	}
}


double Swarm::F(vec2D vec){
	return -20. * exp(-.2 * sqrt(.5 * (pow(vec.x, 2) + pow(vec.y, 2) ) ) ) - 
			exp(.5 * (cos(2 * pi * vec.x) + sin(2 * pi * vec.y))) + e + 20;
}


Swarm::~Swarm(){

}

