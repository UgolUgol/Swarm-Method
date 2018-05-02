#include "VertexBuffer.h"

class CudaBuffer {
	VertexBuffer* buffer;
	GLenum target;
	struct cudaGraphicsResource* resource;
public:
	CudaBuffer(int size, GLenum targ,
	 unsigned int flags=cudaGraphicsMapFlagsWriteDiscard);

	~CudaBuffer();

	bool mapResource(cudaStream_t stream = 0);
	bool unmapResource(cudaStream_t stream = 0);
	bool mappedPointer(uchar4** ptr, size_t& numBytes);

	GLuint getId();
	GLenum getTarget();
	cudaGraphicsResource* getResource();

};
