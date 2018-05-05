#include "glutWrapper.h"
#include <iostream>

 //======================KERNESL=================================

<<<<<<< HEAD
__device__ double ff(double x, double y, double t) {
	return sin(x * x + t) + cos(y * y + 0.6 * t) + sin(x * x + y * y + 0.3 * t);
}

__device__ double fun(int i, int j, double t, int w, int h) {
	double xc = 0.0, yc = 0.0, sx = 5.0, sy = sx * h / w;
	double x = 2.0 * i / (double)(w - 1) - 1.0;
	double y = 2.0 * j / (double)(h - 1) - 1.0;
	return ff(xc + sx * x, yc + sy * y, t);
}

__global__ void kernel(uchar4 *data, double t, int w, int h) {
	int idx = blockIdx.x * blockDim.x + threadIdx.x;
	int idy = blockIdx.y * blockDim.y + threadIdx.y;
	int offsetx = blockDim.x * gridDim.x;
	int offsety = blockDim.y * gridDim.y;
	int i, j;
	double f;
	for(i = idx; i < w; i += offsetx)
		for(j = idy; j < h; j += offsety) {
			f = (fun(i, j, t, w, h) - minf) / (maxf - minf) * 255;
			data[j * w + i] = make_uchar4(0,(int)f, 0, 255);
		}
}


// ================================================================
/*GlutWrapper* class_ptr;
extern "C"{
	void update_callback(){
		class_ptr->update();
	}

	void display_callback(){
		class_ptr->display();
	}
}
*/

// =============================================

VertexBuffer* vbo;
CudaBuffer* buffer = nullptr;
=======
//================================================================
>>>>>>> beta
GlutWrapper* GlutWrapper::class_ptr = nullptr;

// ==============================================

GlutWrapper::GlutWrapper(){

}

GlutWrapper::GlutWrapper(int argc, char** argv, int w, int h,
 const char* name){
	this->w = w;
	this->h = h;
	this->name = name;
	this->dt = 0.01;
	class_ptr = this;
	xc = 0.0, yc = 0.0, sx = 5.0, sy = sx * h / w;

	glutInit(&argc, argv);
	glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA);
	glutInitWindowSize(this->w, this->h);
	glutCreateWindow(this->name);
}

<<<<<<< HEAD
void GlutWrapper::createVertexBuffer(){
	vbo = new VertexBuffer();

	vbo->bind(GL_PIXEL_PACK_BUFFER_ARB);
	vbo->setData(w*h, NULL, GL_DYNAMIC_DRAW);
	vbo->unbind();
}


void GlutWrapper::update(){
	static double t = 0.0;
	uchar4 *data;
	size_t size;
	buffer->mapResource();
	buffer->mappedPointer(&data, size);	
	kernel<<<dim3(32,32), dim3(8,32)>>>(data, t, w, h);
	CSC(cudaGetLastError());
	buffer->unmapResource();

	t += 0.05;
	glutPostRedisplay();
}



=======
>>>>>>> beta
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
<<<<<<< HEAD
	createVertexBuffer();
	buffer = new CudaBuffer(vbo, GL_ARRAY_BUFFER);
=======
	buffer = new CudaBuffer(w * h * sizeof(uchar4), GL_PIXEL_UNPACK_BUFFER_ARB);
>>>>>>> beta
}


void GlutWrapper::renderCycle(){
	glutRunningFuncs();
	glutSetProjection(GL_PROJECTION);
	glutRunSession();
	glutMainLoop();
}

GlutWrapper::~GlutWrapper(){

}
