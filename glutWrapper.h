#include "CudaBuffer.h"
using namespace std;


/* glutWrapper makes only rendering*/

class GlutWrapper {
	static GlutWrapper* class_ptr;

	void display();

	static void update_callback();
	static void display_callback();

	void glutRunningFuncs();
	void glutSetProjection(GLenum mode);
	void glutRunSession();

protected: 
	int w;
	int h;
	
	double xc;
	double yc;
	double sx;
	double sy;
	double dt;

	const char* name;
	CudaBuffer* buffer;
	virtual void update() = 0;

public:
	GlutWrapper();
	GlutWrapper(int argc, char** argv, int w, int h, const char* name);
	~GlutWrapper();

	void renderCycle();
};



