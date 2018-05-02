#include <stdio.h>
#include <stdlib.h>
#include "glutWrapper.h"
using namespace std;



const int w = 1024;
const int h = 648;


int main( int argc, char **argv )
{
	GlutWrapper glut(argc, argv, w, h, "App");
	glut.renderCycle();
	return 0;
}