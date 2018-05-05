#include "vec2D.h"
class Controller {

	void zoom(unsigned char key);
	void camera();
protected:
	double xc;
	double yc;
	double sx;
	double sy;
	double dt;

	int w;
	int h;

	void keys(unsigned char key, int x, int y);
	void setCamera(vec2D m);
public:
	Controller();
	Controller(int w, int h);
	~Controller();

};