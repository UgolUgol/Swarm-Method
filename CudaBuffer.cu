#include "CudaBuffer.h"
#include <iostream>

CudaBuffer::CudaBuffer(int size, 
	GLenum targ, unsigned int flags){
	
	buffer = new VertexBuffer();
	target = targ;

	buffer->bind(target);
	//buffer->setData(size, NULL, GL_DYNAMIC_DRAW);
	cudaGraphicsGLRegisterBuffer(&resource, buffer->getId(), flags);
	buffer->unbind();
}

CudaBuffer::~CudaBuffer(){
	cudaGraphicsUnregisterResource(resource);
}

bool CudaBuffer::mapResource(cudaStream_t stream){
	return cudaGraphicsMapResources(1, &resource, stream) == cudaSuccess;
}

bool CudaBuffer::unmapResource(cudaStream_t stream){
	return cudaGraphicsUnmapResources(1, &resource, stream) == cudaSuccess;
}


bool CudaBuffer::mappedPointer(uchar4** ptr, size_t& numBytes){
	bool success = (cudaGraphicsResourceGetMappedPointer ( (void**)ptr, &numBytes, resource ) == cudaSuccess); 
	return success;   
}


GLuint CudaBuffer::getId(){
	return buffer->getId();
}

GLenum CudaBuffer::getTarget(){
	return target;
}

cudaGraphicsResource* CudaBuffer::getResource(){
	return resource;
}
