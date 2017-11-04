#include <stdio.h>
#include "print.h"

// FILE *fp;

int main() {
	// fp = fopen("sample.out", "w");
	extern int yydebug;
	yydebug = 1;

	extern FILE *yyin;
	yyin = fopen("test-input.txt", "r");

	if (!yyparse())
		dfs();
	

	printf("  *** parsing end ***\n");
	// fprintf(fp, "\n");
	// fclose(fp);
	return 0;
}

void dfs() {
	if (head == NULL) {
		fprintf(stderr, "Program does not exist.\n");
		return;
	}


	if (head->_class != NULL) {
	}

	if (head->mainFunc != NULL) {
	}
}