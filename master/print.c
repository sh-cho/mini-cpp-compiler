#include <stdio.h>
#include "print.h"

FILE *fp;

int main() {
	fp = fopen("symtable.txt", "w");
	extern int yydebug;
	yydebug = 1;

	extern FILE *yyin;
	yyin = fopen("test-input.txt", "r");

	if (!yyparse())
		dfs();
	
	printf("  *** parsing end ***\n");
	fprintf(fp, "\n");
	fclose(fp);
	return 0;
}

void dfs() {
	if (head == NULL) {
		fprintf(stderr, "Program does not exist.\n");
		return;
	}


	if (head->_class != NULL) print_class(head->_class, "", head->_class->_id);
	if (head->classMethodDef != null) print_class_method_def("", head->clsasMethodDef->className);
	if (head->mainFunc != NULL) print_main(head->mainFunc);
}


void print_class(struct Class *p, char *parent, char *current) {
	struct Class *cursor = p;
	while (cursor != NULL) {
		//print class --> skip
		print_member(cursor->priMember, strcat(current), "private");
		print_member(cursor->pubMember, current, "public");
		cursor = cursor->prev;
	}
}

void print_class_method_def(struct ClassMethodDef *p, char *parent, char *current) {
	struct Class *cursor = p;
	

}

void print_main(struct MainFunc *p) {
	struct CompoundStmt *cursor = p;
	
	// char prefix[100];
	// snprintf(prefix, sizeof(prefix), "%s-%s", "main", "abc");
	// printf("%s\n", prefix);
	print_compound_stmt(cursor->compoundStmt, "main", "");
}

void print_member(struct Member *p) {

}

void print_compound_stmt(struct CompoundStmt *p, char *parent, char *current) {

}