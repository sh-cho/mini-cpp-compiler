#include <stdio.h>
#include "print.h"

FILE *fp;

int main() {
	//for debug
	extern int yydebug;
	yydebug = 1;

	// fp = fopen("sample.out", "w");
	yyin = fpen("test-input", "r");

	if (!yyparse())
		print();
	else {
		fprintf(stderr, "Parsing failed");
	}

	// fprintf(fp, "\n");
	// fclose(fp);
	fclose(yyin);
	return 0;
}

void print() {
	if (prog_head == NULL) {
		fprintf(stderr, "Program does not exist.\n");
		return;
	} else {
		printf("Program exist\n");
		return;
	}
	//print
}