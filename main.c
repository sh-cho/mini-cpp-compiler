#include <stdio.h>
#include "AST.h"

FILE *fp;

int main() {
	fp = fopen("sample.out", "w");
	yyparse();
	fprintf(fp, "\n");
	fclose(fp);
	return 0;
}