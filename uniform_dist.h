#include <random>
#include "vec2D.h"

class UniformDist {
	uniform_real_distribution<> distrib;
	mt19937 gen;
	random_device rd;
public:
	UniformDist();
	UniformDist(double low, double high);
	vec2D generate();
	~UniformDist();
};