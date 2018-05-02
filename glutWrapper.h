#include "CudaBuffer.h"
using namespace std;


class GlutWrapper {
	int w;
	int h;
	const char* name;
	static GlutWrapper* class_ptr;

	void update();
	void display();

	static void update_callback();
	static void display_callback();

	void glutRunningFuncs();
	void glutSetProjection(GLenum mode);
	void glutRunSession();
	void createVertexBuffer();

public:
	GlutWrapper();
	GlutWrapper(int argc, char** argv, int w, int h, const char* name);
	~GlutWrapper();

	void renderCycle();
};



