#include <iostream>
using namespace std;

struct vec2D {
	double x;
	double y;

	vec2D(){}
	vec2D(double x, double y){
		this->x = x;
		this->y = y;
	}

	friend ostream& operator<<(ostream& os, vec2D a){
		os<<a.x<<" "<<a.y<<endl;
		return os;
	};
};