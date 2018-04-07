#include "swarm.h"

Swarm::Swarm(int n): objects_count(n){
	pat.resize(objects_count);

	for(auto i = pat.begin(); i != pat.end(); i++){
		double p = pat[i].getLocalOptimum();
		updateOptimum(p);
	}
}