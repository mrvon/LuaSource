#include "main.h"

typedef struct Foo {
	int n;
	char c;
	double f;
	int n2;
} Foo;

int main(void) {
	//test_conf();
	simple_interpreter();
	//test_reg();
	//test_stack();

	//fprintf(stdout, "INT: %d\n", offsetof(Foo, n));
	//fprintf(stdout, "CHAR: %d\n", offsetof(Foo, c));
	//fprintf(stdout, "DOUBLE: %d\n", offsetof(Foo, f));
	//fprintf(stdout, "INT: %d\n", offsetof(Foo, n2));

	getchar();
	return 0;
}
