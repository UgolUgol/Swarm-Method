#include "particle.h"


Particle::Particle(){
	
}

void Particle::init(vec2D opt){
	local_opt = opt;
}
vec2D Particle::getLocalOptimum(){
	return this->local_opt;
}
