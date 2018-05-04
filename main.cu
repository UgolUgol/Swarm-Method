#include <stdio.h>
#include <stdlib.h>
#include "swarm.h"
using namespace std;



/*const int w = 1024;
const int h = 648;*/


int main( int argc, char **argv )
{
	Swarm obj(700, argc, argv);
	obj.run();
	return 0;
}