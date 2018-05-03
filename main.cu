#include <stdio.h>
#include <stdlib.h>
#include "swarm.h"
using namespace std;



/*const int w = 1024;
const int h = 648;*/


int main( int argc, char **argv )
{
	/*GlutWrapper glut(argc, argv, 1024, 648, "App");
	glut.renderCycle();*/
	Swarm obj(980, argc, argv);
	obj.run();
	return 0;
}