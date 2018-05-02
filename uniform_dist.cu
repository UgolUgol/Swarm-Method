#include "uniform_dist.h"


UniformDist::UniformDist(double low, double high){
	gen = mt19937(rd());
	distrib = uniform_real_distribution<>(low, high);
}


vec2D UniformDist::generate(){
	return vec2D(distrib(gen), distrib(gen));
}


UniformDist::~UniformDist(){

}