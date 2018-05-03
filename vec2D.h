#include <iostream>
using namespace std;

struct vec2D {
	double x;
	double y;

	__host__ __device__ vec2D(){

	}
	__host__ __device__ vec2D(double x, double y){
		this->x = x;
		this->y = y;
	}

	friend ostream& operator<<(ostream& os, vec2D a){
		os<<a.x<<" "<<a.y<<endl;
		return os;
	};
	

};