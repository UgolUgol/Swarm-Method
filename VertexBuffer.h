#include <GL/glew.h>
#include <GL/freeglut.h>
#include <cuda_runtime.h>
#include <cuda_gl_interop.h>


#define CSC(call) {														\
	 cudaError err = call;												\
	 if(err != cudaSuccess) {											\
		  fprintf(stderr, "CUDA error in file '%s' in line %i: %s.\n",	\
				__FILE__, __LINE__, cudaGetErrorString(err));			\
		  exit(1);														\
	 }																	\
} while (0)


class VertexBuffer {
	GLuint id;
	GLenum target;
	bool inited;
public:
	VertexBuffer();
	~VertexBuffer();

	GLenum getId();

	void bind(GLenum target);
	void unbind();
	void setData(unsigned size, const void* ptr, GLenum usage);
};