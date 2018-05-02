#include <utility>
#include <iostream>
#include <random>
#include "uniform_dist.h"

using namespace std;

struct parameters{
	double a;
	double b;
	double w;
};


class Particle
{
	vec2D position;
	vec2D speed;
	vec2D local_opt;
public:
	Particle();

	vec2D getLocalOptimum();
	vec2D genPosition();
	// void changePosition();
	// void changeSpeed(double parameters, double g);

	~Particle();
};

