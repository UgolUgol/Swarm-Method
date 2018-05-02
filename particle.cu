#include "particle.h"


Particle::Particle(){
	this->position = genPosition();
	this->local_opt = this->position;
}


vec2D Particle::getLocalOptimum(){
	return this->local_opt;
}

vec2D Particle::genPosition(){
	
}

Particle::~Particle(){

}