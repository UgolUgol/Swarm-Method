#include "VertexBuffer.h"
#include <iostream>
using namespace std;

VertexBuffer::VertexBuffer(){
	glGenBuffers(1, &id);
	inited = (glIsBuffer(id) == GL_TRUE);
	target = 0;
}

VertexBuffer::~VertexBuffer(){
	glDeleteBuffers(1, &id);
}

void VertexBuffer::bind(GLenum targ){
	this->target = targ;
	glBindBuffer(this->target, this->id);
}


void VertexBuffer::unbind(){
	glBindBuffer(target, 0);
}

void VertexBuffer::setData(unsigned size, const void* ptr, GLenum usage){
	glBufferData(target, size, ptr, usage);
}


GLenum VertexBuffer::getId(){
	return id;
}
