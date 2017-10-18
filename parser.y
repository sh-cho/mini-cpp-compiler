	/* declarations */
%{
	#include <stdio.h>
	#include <stdlib.h>
	#include "AST.h"

	int yylex();
	void yyerror(char *);
%}

%token INT FLOAT
%token CLASS


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

Program: ClassList ClassMethodList MainFunc
	| MainFunc
	;

ClassList: Class
	| ClassList Class
	;

Class:
	;
Member:
	;

VarDeclList: VarDecl
	| VarDeclList VarDecl
	;
MethodDeclList: FuncDecl
	| MethodDeclList FuncDecl
	;
MethodDefList: FuncDef
	| MethodDefList FuncDef
	;

VarDecl: Type Ident
	| Type Ident '=' INT
	| Type Ident '=' FLOAT	//-->맞나이거; 아닐듯
	;
FuncDecl:
	;
FuncDef:
	;

ClassMethodList:
	;
ClassMethodDef:
	;

MainFunc:
	;

ParamList:
	;
Param:
	;

Ident:
	;
Type:
	;

CompundStmt:
	;

StmtList:
	;

Stmt: ExprStmt
	| AssignStmt
	| RetStmt
	| WhileStmt
	| DoStmt
	| ForStmt
	| IfStmt
	| CompoundStmt
	;

ExprStmt:
	;
AssignStmt: RefVarExpr '=' Expr
	;
RetStmt:
	;
WhileStmt:
	;
DoStmt:
	;
ForStmt:
	;
IfStmt:
	;

Expr:
	;
OperExpr:
	;
RefExpr:
	;
RefVarExpr:
	;
RefCallExpr:
	;
IdentExpr:
	;
CallExpr:
	;

ArgList:
	;




%%
	/* c code */
int main(void) {
	yyparse();
	return 0;
}

void yyerror(char *s) {
	fprintf(stderr, "error: %s\n", s);
}