#include <utility>

struct vector{
	double x;
	double y;
}

struct parameters{
	double a;
	double b;
	double w;
}


class Particle
{
	vector position;
	vector speed;
	vector local_opt;
public:
	Particle();

	pair<double, double> genParameters();
	vector getLocalOptimum();
	void changePosition();
	void changeSpeed(double parameters, double g);

	~Particle();
};

