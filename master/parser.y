%{
	#include <stdio.h>
	#include <stdlib.h>
	#include "AST.h"

	void yyerror(char *);

	extern int yylineno;
	extern char* yytext;
%}

%error-verbose

%union {
	struct Program *prog;
}

%token INTNUM FLOATNUM
%token CLASS
%token DO
%token ELSE
%token FOR
%token ID
%token IF
%token FLOATTYPE
%token INTTYPE
%token MAIN
%token PRIVATE
%token PUBLIC
%token RETURN
%token UNOP
%token WHILE

%type <prog> Program

%right ASGNOP
%left EQLTOP
%left RELAOP
%left ADDIOP
%left MULTOP
%right UMINUS

%%
	/* rules & actions */

	/** 
	 *	PA1.pdf 내용을 참고.
	 *	+(one or more), *(zero or more), ?(optional) --> 바꾸는 technique (확실하지는 않음)
	 *
	 *	1. +
	 *	ex) declarations := (declaration)+
	 *	-->	declarations: declaration | declarations declaration;
	 *
	 *	2. *
	 *	ex) declarations := (declaration)*
	 *	-->	declarations: (empty) | declarations declaration;
	 *
	 *	3. ?
	 *	ex) program := (readme)?
	 *	-->	program: | readme
	 *	만약 program := (readme)? (makefile)? (license)? 라면 000,001,...,111일 때까지 rule들을 전부 써야 할 듯?
	 *
	 */

Program: ClassList ClassMethodList MainFunc {}
	| MainFunc {}
	;

ClassList: Class {}
	| ClassList Class {}
	;

Class: CLASS ID '{' PRIVATE ':' Member PUBLIC ':' Member '}' {}
	| CLASS ID '{' PRIVATE ':' Member '}' {}
	| CLASS ID '{' PUBLIC ':' Member '}' {}
	;
Member: VarDeclList MethodDeclList MethodDefList {}
	| VarDeclList MethodDeclList {}	//110

	//
	;

VarDeclList: VarDecl {}
	| VarDeclList VarDecl {}
	;
MethodDeclList: FuncDecl {}
	| MethodDeclList FuncDecl {}
	;
MethodDefList: FuncDef {}
	| MethodDefList FuncDef {}
	;

VarDecl: Type Ident ';' {}
	| Type Ident '=' INTNUM ';' {}
	| Type Ident '=' FLOATNUM ';' {}
	;
FuncDecl: Type ID '(' ')' ';' {}
	| Type ID '(' ParamList ')' ';' {}
	;
FuncDef: Type ID '(' ')' CompoundStmt {}
	| Type ID '(' ParamList ')' CompoundStmt {}
	;

ClassMethodList: ClassMethodDef {}
	| ClassMethodList ClassMethodDef {}
	;
ClassMethodDef: Type ID ':' ':' ID '(' ')' CompoundStmt {}
	| Type ID ':' ':' ID '(' ParamList ')' CompoundStmt {}
	;

MainFunc: INTTYPE MAIN '(' ')' CompoundStmt {}
	;

ParamList: Param {}
	| ParamList ',' Param {}
	;
Param: Type Ident {}
	;

Ident: ID {}
	| ID '[' INTNUM ']' {}
	;
Type: INTTYPE {}
	| FLOATTYPE {}
	| ID {}
	;

CompoundStmt: '{' VarDeclList StmtList '}' {}
	| '{' VarDeclList '}' {}
	| '{' StmtList '}' {}
	| '{' '}' {}
	;

StmtList: Stmt {}
	| StmtList Stmt {}
	;

Stmt: ExprStmt {}
	| AssignStmt {}
	| RetStmt {}
	| WhileStmt {}
	| DoStmt {}
	| ForStmt {}
	| IfStmt {}
	| CompoundStmt {}
	| ';' {}
	;

ExprStmt: Expr {}
	;
AssignStmt: RefVarExpr '=' Expr ';' {}
	;
RetStmt: RETURN ';' {}
	| RETURN Expr ';' {}
	;
WhileStmt: WHILE '(' Expr ')' Stmt {}
	;
DoStmt: DO Stmt WHILE '(' Expr ')' ';' {}
	;
ForStmt: FOR '(' Expr ';' Expr ';' Expr ')' Stmt {}
	;
IfStmt: IF '(' Expr ')' Stmt {}
	| IF '(' Expr ')' Stmt ELSE Stmt {}
	;

Expr: OperExpr {}
	| RefExpr {}
	| INTNUM {}
	| FLOATNUM {}
	;
OperExpr: UNOP Expr %prec UMINUS {}
	| Expr ADDIOP Expr {}
	| Expr MULTOP Expr {}
	| Expr RELAOP Expr {}
	| Expr EQLTOP Expr {}
	| '(' Expr ')' {}
	;
RefExpr: RefVarExpr {}
	| RefCallExpr {}
	;
RefVarExpr: IdentExpr {}
	| RefExpr '.' IdentExpr {}
	;
RefCallExpr: CallExpr {}
	| RefExpr '.' CallExpr {}
	;
IdentExpr: ID '[' Expr ']' {}
	| ID {}
	;
CallExpr: ID '(' ArgList ')' {}
	;

ArgList: Expr {}
	| ArgList ',' Expr {}
	| /*empty*/ {}
	;




%%
	/* c code */
void yyerror(char *s) {
	// fprintf(stderr, "error: %s\n", s);
	fprintf(stderr, "%d: error: '%s' at '%s', yylval=%u\n", yylineno, s, yytext, yylval);
}