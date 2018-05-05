#include "controller.h"


Controller::Controller(){

}

Controller::Controller(int w, int h){
	xc = 0.0, yc = 0.0, sx = 5.0, sy = sx * h / w;
	dt = 0.01;

	this->w = w;
	this->h = h;
}

void Controller::zoom(unsigned char key){

	if(key == '+'){
		this->sx -= 0.01;
		this->sy = sx * h / w;
	}
	if(key == '-'){
		this->sx += 0.01;
		this->sy = sx * h / w;
	}
	
}

void Controller::setCamera(vec2D m){
	xc = m.x;
	yc = m.y;
}


void Controller::keys(unsigned char key, int x, int y){

// make zoom
	zoom(key);

}


Controller::~Controller(){

}