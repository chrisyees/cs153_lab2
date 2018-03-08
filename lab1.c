#include "types.h"
#include "user.h"

int fib(int x) {
	if(x == 0)
		return 0;
	if(x == 1)
		return 1;
	if(x == 2)
		return 2;
	if(x == 3)
		return 3;
        printf(1,"\n%d",x);
	return fib(x - 1) * fib(x - 2) * fib(x - 3) * fib(x - 4);
}

int main(int argc, char *argv[])
{

	int x = atoi(argv[1]);
	x = fib(x);
	printf(1,"\nResult: %d\n", x);
	exit();
	return 0;
}

