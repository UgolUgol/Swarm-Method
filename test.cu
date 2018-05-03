#include <iostream>


using namespace std;


class a{
public:
	int x;
	a(){

	}
	a(int i){
		x = i;
	}

	void check(){
		disp();
	}

	virtual void disp() = 0;
};

class b : public a{
public:
	b(){

	}
	b(int i) : a(i){

	}

	void get(){
		check();
	}

	void disp(){
		cout<<x;
	}
};

int main(int argc, char const *argv[])
{
	b obj(3);
	obj.get();
	return 0;
}