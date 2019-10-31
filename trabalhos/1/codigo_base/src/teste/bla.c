#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// strtol (https://www.tutorialspoint.com/c_standard_library/c_function_strtol.htm)
// struct para symb;
// struct para rot;
struct key_val{
	char* rotulo;
	int endereço;
	int eDireita;
};

struct key_val[100];
int tam_key_val;


int main() {
	tam_key_val = 0;

	char temp[100];
	int a = 15;

	sprintf(temp, "%02X %03d ", a, 32878);
	printf("%s\n", temp);
	return 0;
}
