#include "glutWrapper.h"
#include <iostream>

 //======================KERNESL=================================

//================================================================
GlutWrapper* GlutWrapper::class_ptr = nullptr;

GlutWrapper::GlutWrapper(){

}

GlutWrapper::GlutWrapper(int argc, char** argv, int w, int h,
 const char* name){
	this->w = w;
	this->h = h;
	this->name = name;
	this->dt = 0.01;
	class_ptr = this;
	xc = 0.0, yc = 0.0, sx = 10.0, sy = sx * h / w;

	glutInit(&argc, argv);
	glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA);
	glutInitWindowSize(this->w, this->h);
	glutCreateWindow(this->name);
}

void GlutWrapper::display(){
	glClearColor(0.0, 0.0, 0.0, 1.0);
	glClear(GL_COLOR_BUFFER_BIT);
	glDrawPixels(w, h, GL_RGBA, GL_UNSIGNED_BYTE, 0);
	glutSwapBuffers();
}


void GlutWrapper::update_callback(){
	class_ptr->update();
}

void GlutWrapper::display_callback(){
	class_ptr->display();
}

void GlutWrapper::glutRunningFuncs(){
	glutIdleFunc(update_callback);	
	glutDisplayFunc(display_callback);
}



void GlutWrapper::glutSetProjection(GLenum mode){
	glMatrixMode(mode);
	glLoadIdentity();
	gluOrtho2D(0.0, (GLdouble)w, 0.0, (GLdouble)h);	
	glewInit();
}


void GlutWrapper::glutRunSession(){
	buffer = new CudaBuffer(w * h * sizeof(uchar4), GL_PIXEL_UNPACK_BUFFER_ARB);
}


void GlutWrapper::renderCycle(){
	glutRunningFuncs();
	glutSetProjection(GL_PROJECTION);
	glutRunSession();
	glutMainLoop();
}

GlutWrapper::~GlutWrapper(){

}
