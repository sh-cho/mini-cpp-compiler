%{
	#include <stdio.h>
	#include <stdlib.h>
	#include "AST-test.h"
	#include "print.h"

	int yylex();
	int yyparse();
	void yyerror(char *);

	extern int yylineno;
	extern char* yytext;
%}

%union {
	struct Program *program;
	struct Class *_class;
	struct MainFunc *mainFunc;
	char *id;
	int intnum;
}

%token ID
%token INTNUM
%token INTTYPE
%token CLASS
%token PRIVATE

%type<id>	ID;
%type<intnum>	INTNUM;

%type<program>	Program;
%type<_class>	Class;
%type<_class>	ClassList;
%type<mainFunc>	MainFunc;

%%

Program: MainFunc
		{
			//make ast
			struct Program *prog = (struct Program*)malloc(sizeof(struct Program));
			prog->_class = NULL;
			prog->mainFunc = $1;

			prog_head = prog;
			
			$$ = prog;
		}
	| ClassList MainFunc
		{
			//make ast
			struct Program *prog = (struct Program*)malloc(sizeof(struct Program));
			prog->_class = $1;
			prog->mainFunc = $2;

			prog_head = prog;

			$$ = prog;
		}
	;

ClassList: Class
		{
			$$ = $1;
		}
	| ClassList Class
		{
			$2->prev = $1;
			$$ = $2;
		}
	;

Class: CLASS ID '{' INTNUM '}'
		{
			struct Class *new_class = (struct Class*)malloc(sizeof(struct Class));
			new_class->id = $2;
			new_class->mem1 = $6;
			$$ = new_class;
		}
	;

MainFunc: INTTYPE 'm' 'a' 'i' 'n' '(' ')' '{' ID '}'
		{
			struct MainFunc *new_main = (struct MainFunc*)malloc(sizeof(struct MainFunc));
			new_main->body = $9;
			$$ = new_main;
		}
	;

%%
	/* c code */
void yyerror(char *s) {
	// fprintf(stderr, "error: %s\n", s);
	// printf("%d: %s at %s\n", yylineno, s, yytext);
	fprintf(stderr, "%d: error: '%s' at '%s', yylval=%u\n", yylineno, s, yytext, yylval);
}