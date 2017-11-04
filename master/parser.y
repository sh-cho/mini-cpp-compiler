%{
	#include <stdio.h>
	#include <stdlib.h>
	#include "AST.h"
	#include "print.h"

	void yyerror(char *);

	extern int yylineno;
	extern char* yytext;
%}

%error-verbose

%union {
	struct Program *prog;
	struct Class *_class;
	struct MainFunc *mainFunc;
	struct Member *member;
	struct VarDecl *varDecl;
	struct MethodDecl *methodDecl;
	struct MethodDef *methodDef;
	struct ClassMethodDef *classMethodDef;
	struct Param *param;
	struct Ident *ident;
	struct Type *type;
	struct CompoundStmt *compoundStmt;
	struct Stmt *stmt;
	struct ExprStmt *exprStmt;
	struct AssignStmt *assignStmt;
	struct RetStmt *retStmt;
	struct WhileStmt *whileStmt;
	struct DoStmt *doStmt;
	struct ForStmt *forStmt;
	struct IfStmt *ifStmt;
	struct Expr *expr;
	struct OperExpr *operExpr;
	struct RefExpr *refExpr;
	struct RefVarExpr *refVarExpr;
	struct RefCallExpr *refCallExpr;
	struct IdentExpr *identExpr;
	struct CallExpr *callExpr;
	struct Arg *arg;
	struct UnOp *unOp;
	struct AddiOp *addiOp;
	struct MultOp *multOp;
	struct RelaOp *relaOp;
	struct EqltOp *eqltOp;

	char *id;
	int intnum;
	float floatnum;
}

%token <intnum>INTNUM <floatnum>FLOATNUM
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
%type <_class> Class
%type <mainFunc> MainFunc
%type <member> Member;
%type <varDecl> VarDecl;
%type <methodDecl> MethodDecl;
%type <methodDef> MethodDef;
%type <classMethodDef> ClassMethodDef;
%type <param> Param;
%type <ident> Ident;
%type <type> Type;
%type <compoundStmt> CompoundStmt;
%type <stmt> Stmt;
%type <exprStmt> ExprStmt;
%type <assignStmt> AssignStmt;
%type <retStmt> RetStmt;
%type <whileStmt> WhileStmt;
%type <doStmt> DoStmt;
%type <forStmt> ForStmt;
%type <ifStmt> IfStmt;
%type <expr> Expr;
%type <operExpr> OperExpr;
%type <refExpr> RefExpr;
%type <refVarExpr> RefVarExpr;
%type <refCallExpr> RefCallExpr;
%type <identExpr> IdentExpr;
%type <callExpr> CallExpr;
%type <arg> Arg;
%type <unOp> UnOp;
%type <addiOp> AddiOp;
%type <multOp> MultOp;
%type <relaOp> RelaOp;
%type <eqltOp> EqltOp;

%right ASGNOP
%left EQLTOP
%left RELAOP
%left ADDIOP
%left MULTOP

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
		{
			struct Program *prog = (struct Program*)malloc(sizeof(struct Program));
			prog->_class = $1;
			prog->classMethodDef = $2;
			prog->mainFunc = $3;

			head = prog;
			$$ = prog;
		}
	| MainFunc
		{
			struct Program *prog = (struct Program*)malloc(sizeof(struct Program));
			prog->_class = NULL;
			prog->mainFunc = $1;

			head = prog;
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

Class: CLASS ID '{' PRIVATE ':' Member PUBLIC ':' Member '}'
		{
			struct Class *new_class = (struct Class*)malloc(sizeof(struct Class));
			new_class->id = $2;
			new_class->priMember = $6;
			new_class->pubMember = $9;

			$$ = new_class;
		}
	| CLASS ID '{' PRIVATE ':' Member '}'
		{
			struct Class *new_class = (struct Class*)malloc(sizeof(struct Class));
			new_class->id = $2;
			new_class->priMember = $6;
			new_class->pubMember = NULL;

			$$ = new_class;
		}
	| CLASS ID '{' PUBLIC ':' Member '}'
		{
			struct Class *new_class = (struct Class*)malloc(sizeof(struct Class));
			new_class->id = $2;
			new_class->priMember = NULL;
			new_class->pubMember = $6;

			$$ = new_class;
		}
	;
Member: VarDeclList MethodDeclList MethodDefList
		{
			struct Member *new_mem = (struct Member *)malloc(sizeof(struct Member));

			new_mem->varDecl = $1;
			new_mem->methodDecl = $2;
			new_mem->methodDef = $3;

			$$ = new_mem;
		}
	| VarDeclList MethodDeclList
		{
			struct Member *new_mem = (struct Member *)malloc(sizeof(struct Member));

			new_mem->varDecl = $1;
			new_mem->methodDecl = $2;
			new_mem->methodDef = NULL;

			$$ = new_mem;
		}
	| VarDeclList MethodDefList
		{
			struct Member *new_mem = (struct Member *)malloc(sizeof(struct Member));

			new_mem->varDecl = $1;
			new_mem->methodDecl = NULL;
			new_mem->methodDef = $3;

			$$ = new_mem;
		}
	| VarDeclList
		{
			struct Member *new_mem = (struct Member *)malloc(sizeof(struct Member));

			new_mem->varDecl = $1;
			new_mem->methodDecl = NULL;
			new_mem->methodDef = NULL;

			$$ = new_mem;
		}
	| MethodDeclList MethodDefList
		{
			struct Member *new_mem = (struct Member *)malloc(sizeof(struct Member));

			new_mem->varDecl = NULL;
			new_mem->methodDecl = $2;
			new_mem->methodDef = $3;

			$$ = new_mem;
		}
	| MethodDeclList
		{
			struct Member *new_mem = (struct Member *)malloc(sizeof(struct Member));

			new_mem->varDecl = NULL;
			new_mem->methodDecl = $2;
			new_mem->methodDef = NULL;

			$$ = new_mem;
		}
	| MethodDefList
		{
			struct Member *new_mem = (struct Member *)malloc(sizeof(struct Member));

			new_mem->varDecl = NULL;
			new_mem->methodDecl = NULL;
			new_mem->methodDef = $3;

			$$ = new_mem;
		}
	|	{
			struct Member *new_mem = (struct Member *)malloc(sizeof(struct Member));

			new_mem->varDecl = NULL;
			new_mem->methodDecl = NULL;
			new_mem->methodDef = NULL;

			$$ = new_mem;
		}
	;

VarDeclList: VarDecl
		{
			$$ = $1;
		}
	| VarDeclList VarDecl
		{
			$2->prev = $1;
			$$ = $2;
		}
	;
MethodDeclList: FuncDecl
		{
			$$ = $1;
		}
	| MethodDeclList FuncDecl
		{
			$2->prev = $1;
			$$ = $2;
		}
	;
MethodDefList: FuncDef
		{
			$$ = $1;
		}
	| MethodDefList FuncDef
		{
			$2->prev = $1;
			$$ = $2;
		}
	;

VarDecl: Type Ident ';'
		{
			struct VarDecl *vardecl = (struct VarDecl *)malloc(sizeof(struct VarDecl));
			vardecl->type = $1;
			vardecl->ident = $2;
			vardecl->expr = NULL;	//TODO

			$$ = vardecl;
		}
	| Type Ident '=' INTNUM ';'
		{
			struct VarDecl *vardecl = (struct VarDecl *)malloc(sizeof(struct VarDecl));
			vardecl->type = $1;
			vardecl->ident = $2;
			vardecl->expr = NULL;	//TODO
			
			//expression ?
			//struct Expr *expr = 

			$$ = vardecl;
		}
	| Type Ident '=' FLOATNUM ';'
		{
			struct VarDecl *vardecl = (struct VarDecl *)malloc(sizeof(struct VarDecl));
			vardecl->type = $1;
			vardecl->ident = $2;
			vardecl->expr = NULL;	//TODO

			$$ = vardecl;
		}
	;
FuncDecl: Type ID '(' ')' ';'
		{
			// == MethodDecl
			struct MethodDecl *methodDecl = (struct MethodDecl *)malloc(struct MethodDecl);

			methodDecl->id = $2;
			methodDecl->type = $1;
			methodDecl->param = NULL;

			$$ = methodDecl;
		}
	| Type ID '(' ParamList ')' ';'
		{
			struct MethodDecl *methodDecl = (struct MethodDecl *)malloc(struct MethodDecl);

			methodDecl->id = $2;
			methodDecl->type = $1;
			methodDecl->param = $4;

			$$ = methodDecl;
		}
	;
FuncDef: Type ID '(' ')' CompoundStmt
		{
			struct MethodDef *methodDef = (struct MethodDef *)malloc(sizeof(struct MethodDef));

			methodDef->id = $2;
			methodDef->type = $1;
			methodDef->param = NULL;
			methodDef->compoundStmt = $5;

			$$ = methodDef;
		}
	| Type ID '(' ParamList ')' CompoundStmt
		{
			struct MethodDef *methodDef = (struct MethodDef *)malloc(sizeof(struct MethodDef));

			methodDef->id = $2;
			methodDef->type = $1;
			methodDef->param = $4;
			methodDef->compoundStmt = $6;

			$$ = methodDef;
		}
	;

ClassMethodList: ClassMethodDef
		{
			$$ = $1;
		}
	| ClassMethodList ClassMethodDef
		{
			$2->prev = $1;
			$$ = $2;
		}
	;
ClassMethodDef: Type ID ':' ':' ID '(' ')' CompoundStmt
		{
			struct ClassMethodDef *classMethodDef = (struct ClassMethodDef*)malloc(sizeof(struct ClassMethodDef));

			//TODO: 타입?
			classMethodDef->className = $2;
			classMethodDef->methodName = $5;
			classMethodDef->param = NULL;
			classMethodDef->compoundStmt = $8;

			$$ = classMethodDef;
		}
	| Type ID ':' ':' ID '(' ParamList ')' CompoundStmt
		{
			struct ClassMethodDef *classMethodDef = (struct ClassMethodDef*)malloc(sizeof(struct ClassMethodDef));

			//TODO: 타입?
			classMethodDef->className = $2;
			classMethodDef->methodName = $5;
			classMethodDef->param = $7;
			classMethodDef->compoundStmt = $9;

			$$ = classMethodDef;
		}
	;

MainFunc: INTTYPE MAIN '(' ')' CompoundStmt
		{
			struct MainFunc *new_main = (struct MainFunc *)malloc(sizeof(struct MainFunc));
			new_main->compoundStmt = $5;

			$$ = new_main;
		}
	;

ParamList: Param
		{
			$$ = $1;
		}
	| ParamList ',' Param 
		{
			$3->prev = $1;
			$$ = $3;
		}
	;
Param: Type Ident 
		{
			struct Param *param = (struct Param *)malloc(sizeof(struct Param));
			param->type = $1;
			param->ident = $2;

			$$ = param;
		}
	;

Ident: ID
		{
			struct Ident *ident = (struct Ident*)malloc(sizeof(struct Ident));
			ident->id = $1;
			ident->len = 0;
			$$ = ident;
		}
	| ID '[' INTNUM ']'
		{
			struct Ident *ident = (struct Ident*)malloc(sizeof(struct Ident));
			ident->id = $1;
			ident->len = $3;
			$$ = ident;
		}
	;
Type: INTTYPE {}
	| FLOATTYPE {}
	| ID {}
	;

CompoundStmt: '{' VarDeclList StmtList '}' {}
	| '{' VarDeclList '}' {}
	| '{' StmtList '}' {}
	| '{' '}'
		{

		}
	;

StmtList: Stmt 
		{
			$$ = $1;
		}
	| StmtList Stmt
		{
			$2->prev = $1;
			$$ = $2;
		}
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
OperExpr: UNOP Expr /*%prec UMINUS*/ {}
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
CallExpr: ID '(' ')' {}
	| ID '(' ArgList ')' {}
	;

ArgList: Expr
		{
			$$ = $1;
		}
	| ArgList ',' Expr
		{
			$3->prev = $1;
			$$ = $3;
		}
	;



%%
	/* c code */
void yyerror(char *s) {
	// fprintf(stderr, "error: %s\n", s);
	fprintf(stderr, "%d: error: '%s' at '%s', yylval=%u\n", yylineno, s, yytext, yylval);
}