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

	if (head->_class == NULL) {
		printf("  *** There is no Class\n");
	} else {
		printf("  *** Class exists\n");
	}

	if (head->mainFunc == NULL) {
		printf("  *** there is no main\n");
	} else {
		printf("  *** main exists\n");
	}
}