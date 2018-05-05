CC=nvcc
CFLAGS=-std=c++11 -Werror cross-execution-space-call -lm -rdc=true
GLUTFOLD = -I/usr/include -L/usr/lib/x86_64-linux-gnu
GLUT = -lGL -lglut -lGLU -lGLEW -lX11 -lm -lrt -lpng

all: main

clean: 
	rm -rf main *.o

main: 
	$(CC) $(CFLAGS) $(GLUTFOLD) main.cu swarm.cu particle.cu uniform_dist.cu glutWrapper.cu CudaBuffer.cu VertexBuffer.cu $(GLUT) -o main

# vertex.o: VertexBuffer.cu
# 	$(CC) $(CFLAGS) -c VertexBuffer.cu

# cudabuf.o: CudaBuffer.cu
# 	$(CC) $(CFLAGS) -c CudaBuffer.cu

# glut.o: glutWrapper.cu
# 	$(CC) $(CFLAGS) -c glutWrapper.cu	

# uniform_dist.o: uniform_dist.cu
# 	$(CC) $(CFLAGS) -c uniform_dist.cu

# particle.o: particle.cu
# 	$(CC) $(CFLAGS) -c particle.cu	

# swarm.o: swarm.cu
# 	$(CC) -rdc=true $(CFLAGS) -c swarm.cu

# main.o: main.cu
# 	$(CC) $(CFLAGS) -c main.cu 

