#include "VertexBuffer.h"

class CudaBuffer {
	VertexBuffer* buffer;
	GLenum target;
	struct cudaGraphicsResource* resource;
public:
<<<<<<< HEAD
	CudaBuffer(VertexBuffer* buf, GLenum targ,
=======
	CudaBuffer(unsigned size, GLenum targ,
>>>>>>> beta
	 unsigned int flags=cudaGraphicsMapFlagsWriteDiscard);

	~CudaBuffer();

	bool mapResource(cudaStream_t stream = 0);
	bool unmapResource(cudaStream_t stream = 0);
	bool mappedPointer(uchar4** ptr, size_t& numBytes);

	GLuint getId();
	GLenum getTarget();
	cudaGraphicsResource* getResource();

};
