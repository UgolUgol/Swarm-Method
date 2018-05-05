#include "CudaBuffer.h"
#include "controller.h"
using namespace std;


/* glutWrapper makes only rendering*/

class GlutWrapper: protected Controller {
	static GlutWrapper* class_ptr;

	void display();

	static void update_callback();
	static void display_callback();
	static void keys_callback(unsigned char key, int x, int y);

	void glutRunningFuncs();
	void glutSetProjection(GLenum mode);
	void glutRunSession();

protected: 	
	const char* name;
	CudaBuffer* buffer;
	virtual void update() = 0;
public:
	GlutWrapper();
	GlutWrapper(int argc, char** argv, int w, int h, const char* name);
	~GlutWrapper();

	void renderCycle();
};



