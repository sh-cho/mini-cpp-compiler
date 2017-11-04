#include <stdio.h>
#include "print.h"

// FILE *fp;

int main() {
	// fp = fopen("sample.out", "w");

	extern FILE *yyin;
	yyin = fopen("test-input.txt", "r");

	if (!yyparse())
		dfs();
	
	// fprintf(fp, "\n");
	// fclose(fp);
	return 0;
}

void dfs() {
	// if (head == NULL) {
	// 	fprintf(stderr, "Program does not exist.\n");
	// 	return;
	// }
}