%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
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

	char *addiop;
	char *multop;
	char *relaop;
	char *eqltop;
}

%token <intnum>INTNUM <floatnum>FLOATNUM
%token UNOP
%token <addiop>ADDIOP <multop>MULTOP <relaop>RELAOP <eqltop>EQLTOP
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

%type<id>	ID

%type <prog> Program
%type <_class> ClassList Class
%type <mainFunc> MainFunc
%type <member> Member
%type <varDecl> VarDeclList VarDecl
%type <methodDecl> MethodDeclList MethodDecl
%type <methodDef> MethodDefList MethodDef
%type <classMethodDef> ClassMethodList ClassMethodDef
%type <param> ParamList Param
%type <ident> Ident
%type <type> Type
%type <compoundStmt> CompoundStmt
%type <stmt> StmtList Stmt
%type <exprStmt> ExprStmt
%type <assignStmt> AssignStmt
%type <retStmt> RetStmt
%type <whileStmt> WhileStmt
%type <doStmt> DoStmt
%type <forStmt> ForStmt
%type <ifStmt> IfStmt
%type <expr> Expr
%type <operExpr> OperExpr
%type <refExpr> RefExpr
%type <refVarExpr> RefVarExpr
%type <refCallExpr> RefCallExpr
%type <identExpr> IdentExpr
%type <callExpr> CallExpr
%type <arg> ArgList
%type <unOp> UnOp
%type <addiOp> AddiOp
%type <multOp> MultOp
%type <relaOp> RelaOp
%type <eqltOp> EqltOp

%right '='
%left EQLTOP
%left RELAOP
%left ADDIOP
%left MULTOP
%right UNOP

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
			new_mem->methodDef = $2;

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
			new_mem->methodDecl = $1;
			new_mem->methodDef = $2;

			$$ = new_mem;
		}
	| MethodDeclList
		{
			struct Member *new_mem = (struct Member *)malloc(sizeof(struct Member));

			new_mem->varDecl = NULL;
			new_mem->methodDecl = $1;
			new_mem->methodDef = NULL;

			$$ = new_mem;
		}
	| MethodDefList
		{
			struct Member *new_mem = (struct Member *)malloc(sizeof(struct Member));

			new_mem->varDecl = NULL;
			new_mem->methodDecl = NULL;
			new_mem->methodDef = $1;

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
MethodDeclList: MethodDecl
		{
			$$ = $1;
		}
	| MethodDeclList MethodDecl
		{
			$2->prev = $1;
			$$ = $2;
		}
	;
MethodDefList: MethodDef
		{
			$$ = $1;
		}
	| MethodDefList MethodDef
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
MethodDecl: Type ID '(' ')' ';'
		{
			// == MethodDecl
			struct MethodDecl *methodDecl = (struct MethodDecl *)malloc(sizeof(struct MethodDecl));

			methodDecl->id = $2;
			methodDecl->type = $1;
			methodDecl->param = NULL;

			$$ = methodDecl;
		}
	| Type ID '(' ParamList ')' ';'
		{
			struct MethodDecl *methodDecl = (struct MethodDecl *)malloc(sizeof(struct MethodDecl));

			methodDecl->id = $2;
			methodDecl->type = $1;
			methodDecl->param = $4;

			$$ = methodDecl;
		}
	;
MethodDef: Type ID '(' ')' CompoundStmt
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

			classMethodDef->type = $1;
			classMethodDef->className = $2;
			classMethodDef->methodName = $5;
			classMethodDef->param = NULL;
			classMethodDef->compoundStmt = $8;

			$$ = classMethodDef;
		}
	| Type ID ':' ':' ID '(' ParamList ')' CompoundStmt
		{
			struct ClassMethodDef *classMethodDef = (struct ClassMethodDef*)malloc(sizeof(struct ClassMethodDef));

			classMethodDef->type = $1;
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
Type: INTTYPE
		{
			struct Type *type = (struct Type*)malloc(sizeof(struct Type));
			type->id = NULL;
			type->e = eInt;
			$$ = type;
		}
	| FLOATTYPE
		{
			struct Type *type = (struct Type*)malloc(sizeof(struct Type));
			type->id = NULL;
			type->e = eFloat;
			$$ = type;
		}
	| ID
		{
			struct Type *type = (struct Type*)malloc(sizeof(struct Type));
			type->id = $1;
			type->e = eClass;
			$$ = type;
		}
	;

CompoundStmt: '{' VarDeclList StmtList '}'
		{
			struct CompoundStmt *comp = (struct CompoundStmt*)malloc(sizeof(struct CompoundStmt));

			comp->varDecl = $2;
			comp->stmt = $3;

			$$ = comp;
		}
	| '{' VarDeclList '}'
		{
			struct CompoundStmt *comp = (struct CompoundStmt*)malloc(sizeof(struct CompoundStmt));

			comp->varDecl = $2;
			comp->stmt = NULL;

			$$ = comp;
		}
	| '{' StmtList '}'
		{
			struct CompoundStmt *comp = (struct CompoundStmt*)malloc(sizeof(struct CompoundStmt));

			comp->varDecl = NULL;
			comp->stmt = $2;

			$$ = comp;
		}
	| '{' '}'
		{
			struct CompoundStmt *comp = (struct CompoundStmt*)malloc(sizeof(struct CompoundStmt));

			comp->varDecl = NULL;
			comp->stmt = NULL;

			$$ = comp;
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

Stmt: ExprStmt
		{
			//union
			//--> union.type 접근해야 함
			struct Stmt* stmt = (struct Stmt*)malloc(sizeof(struct Stmt));
			stmt->e = eExpr;
			stmt->type.exprStmt = $1;
			$$ = stmt;
		}
	| AssignStmt
		{
			struct Stmt* stmt = (struct Stmt*)malloc(sizeof(struct Stmt));
			stmt->e = eAssign;
			stmt->type.assignStmt = $1;
			$$ = stmt;
		}
	| RetStmt
		{
			struct Stmt* stmt = (struct Stmt*)malloc(sizeof(struct Stmt));
			stmt->e = eRet;
			stmt->type.retStmt = $1;
			$$ = stmt;
		}
	| WhileStmt
		{
			struct Stmt* stmt = (struct Stmt*)malloc(sizeof(struct Stmt));
			stmt->e = eWhile;
			stmt->type.whileStmt = $1;
			$$ = stmt;
		}
	| DoStmt
		{
			struct Stmt* stmt = (struct Stmt*)malloc(sizeof(struct Stmt));
			stmt->e = eDo;
			stmt->type.doStmt = $1;
			$$ = stmt;
		}
	| ForStmt
		{
			struct Stmt* stmt = (struct Stmt*)malloc(sizeof(struct Stmt));
			stmt->e = eFor;
			stmt->type.forStmt = $1;
			$$ = stmt;
		}
	| IfStmt
		{
			struct Stmt* stmt = (struct Stmt*)malloc(sizeof(struct Stmt));
			stmt->e = eIf;
			stmt->type.ifStmt = $1;
			$$ = stmt;
		}
	| CompoundStmt
		{
			struct Stmt* stmt = (struct Stmt*)malloc(sizeof(struct Stmt));
			stmt->e = eCompound;
			stmt->type.compoundStmt = $1;
			$$ = stmt;
		}
	| ';'
		{
			struct Stmt* stmt = (struct Stmt*)malloc(sizeof(struct Stmt));
			stmt->e = eSemi;
			//stmt->type.exprStmt = $1;
			$$ = stmt;
		}
	;

ExprStmt: Expr
		{
			struct ExprStmt *exprStmt = (struct ExprStmt*)malloc(sizeof(struct ExprStmt));
			exprStmt->expr = $1;
			$$ = exprStmt;
		}
	;
AssignStmt: RefVarExpr '=' Expr ';'
		{
			struct AssignStmt *assignStmt = (struct AssignStmt*)malloc(sizeof(assignStmt));
			assignStmt->refVarExpr = $1;
			assignStmt->expr = $3;
			$$ = assignStmt;
		}
	;
RetStmt: RETURN ';'
		{
			struct RetStmt *retStmt = (struct RetStmt*)malloc(sizeof(struct RetStmt));
			retStmt->expr = NULL;
			$$ = retStmt;
		}
	| RETURN Expr ';'
		{
			struct RetStmt *retStmt = (struct RetStmt*)malloc(sizeof(RetStmt));
			retStmt->expr = $2;
			$$ = retStmt;
		}
	;
WhileStmt: WHILE '(' Expr ')' Stmt
		{
			struct WhileStmt *whileStmt = (struct WhileStmt*)malloc(sizeof(struct WhileStmt));
			whileStmt->cond = $3;
			whileStmt->body = $5;
			$$ = whileStmt;
		}
	;
DoStmt: DO Stmt WHILE '(' Expr ')' ';'
		{
			struct DoStmt *doStmt = (struct DoStmt*)malloc(sizeof(struct DoStmt));
			doStmt->cond = $5;
			doStmt->body = $2;
			$$ = doStmt;
		}
	;
ForStmt: FOR '(' Expr ';' Expr ';' Expr ')' Stmt
		{
			struct ForStmt *forStmt = (struct ForStmt*)malloc(sizeof(struct ForStmt));
			forStmt->init = $3;
			forStmt->cond = $5;
			forStmt->incr = $7;
			forStmt->body = $9;
			$$ = forStmt;
		}
	;
IfStmt: IF '(' Expr ')' Stmt
		{
			struct IfStmt *ifStmt = (struct IfStmt*)malloc(sizeof(struct IfStmt));
			ifStmt->cond = $3;
			ifStmt->ifBody = $5;
			ifStmt->elseBody = NULL;
			$$ = ifStmt;
		}
	| IF '(' Expr ')' Stmt ELSE Stmt
		{
			struct IfStmt *ifStmt = (struct IfStmt*)malloc(sizeof(struct IfStmt));
			ifStmt->cond = $3;
			ifStmt->ifBody = $5;
			ifStmt->elseBody = $7;
			$$ = ifStmt;
		}
	;

Expr: OperExpr
		{
			//struct Stmt* stmt = (struct Stmt*)malloc(sizeof(struct Stmt));
			//stmt->e = eExpr;
			//stmt->type.exprStmt = $1;
			//$$ = stmt;
			struct Expr* expr = (struct Expr*)malloc(sizeof(struct Expr));
			expr->e = eOper;
			expr->type.operExpr = $1;
			$$ = expr;
		}
	| RefExpr
		{
			struct Expr* expr = (struct Expr*)malloc(sizeof(struct Expr));
			expr->e = eRef;
			expr->type.refExpr = $1;
			$$ = expr;
		}
	| INTNUM
		{
			struct Expr* expr = (struct Expr*)malloc(sizeof(struct Expr));
			expr->e = eIntnum;
			expr->type.intnum = $1;
			$$ = expr;
		}
	| FLOATNUM
		{
			struct Expr* expr = (struct Expr*)malloc(sizeof(struct Expr));
			expr->e = eFloatnum;
			expr->type.floatnum = $1;
			$$ = expr;
		}
	;
OperExpr: UnOp Expr /*%prec UMINUS*/
		{
			struct OperExpr *operExpr = (struct OperExpr*)malloc(sizeof(struct OperExpr));
			operExpr->e = eUn;
			operExpr->type.un = $1;
			operExpr->type.un->expr = $2;
			$$ = operExpr;
		}
	| Expr AddiOp Expr
		{
			struct OperExpr *operExpr = (struct OperExpr*)malloc(sizeof(struct OperExpr));
			operExpr->e = eAddi;

			operExpr->type.addi = $2;
			operExpr->type.addi->lhs = $1;
			operExpr->type.addi->rhs = $3;
			$$ = operExpr;
		}
	| Expr MultOp Expr
		{
			struct OperExpr *operExpr = (struct OperExpr*)malloc(sizeof(struct OperExpr));
			operExpr->e = eMult;

			operExpr->type.mult = $2;
			operExpr->type.mult->lhs = $1;
			operExpr->type.mult->rhs = $3;
			$$ = operExpr;
		}
	| Expr RelaOp Expr
		{
			struct OperExpr *operExpr = (struct OperExpr*)malloc(sizeof(struct OperExpr));
			operExpr->e = eRela;

			operExpr->type.rela = $2;
			operExpr->type.rela->lhs = $1;
			operExpr->type.rela->rhs = $3;
			$$ = operExpr;
		}
	| Expr EqltOp Expr
		{
			struct OperExpr *operExpr = (struct OperExpr*)malloc(sizeof(struct OperExpr));
			operExpr->e = eEqlt;

			operExpr->type.eqlt = $2;
			operExpr->type.eqlt->lhs = $1;
			operExpr->type.eqlt->rhs = $3;
			$$ = operExpr;
		}
	| '(' Expr ')'
		{
			struct OperExpr *operExpr = (struct OperExpr*)malloc(sizeof(struct OperExpr));
			operExpr->e = eBracket;
			operExpr->type.bracket = $2;
			$$ = operExpr;
		}
	;
RefExpr: RefVarExpr
		{
			struct RefExpr *refExpr = (struct RefExpr*)malloc(sizeof(struct RefExpr));
			refExpr->e = eVar;
			refExpr->type.refVarExpr = $1;
			$$ = refExpr;
		}
	| RefCallExpr
		{
			struct RefExpr *refExpr = (struct RefExpr*)malloc(sizeof(struct RefExpr));
			refExpr->e = eCall;
			refExpr->type.refCallExpr = $1;
			$$ = refExpr;
		}
	;
RefVarExpr: IdentExpr
		{
			struct RefVarExpr *refVarExpr = (struct RefVarExpr*)malloc(sizeof(struct RefVarExpr));
			refVarExpr->refExpr = NULL;
			refVarExpr->identExpr = $1;
			$$ = refVarExpr;
		}
	| RefExpr '.' IdentExpr
		{
			struct RefVarExpr *refVarExpr = (struct RefVarExpr*)malloc(sizeof(struct RefVarExpr));
			refVarExpr->refExpr = $1;
			refVarExpr->identExpr = $3;
			$$ = refVarExpr;
		}
	;
RefCallExpr: CallExpr
		{
			struct RefCallExpr *refCallExpr = (struct RefCallExpr*)malloc(sizeof(struct RefCallExpr));
			refCallExpr->refExpr = NULL;
			refCallExpr->callExpr = $1;
			$$ = refCallExpr;
		}
	| RefExpr '.' CallExpr
		{
			struct RefCallExpr *refCallExpr = (struct RefCallExpr*)malloc(sizeof(struct RefCallExpr));
			refCallExpr->refExpr = $1;
			refCallExpr->callExpr = $3;
			$$ = refCallExpr;
		}
	;
IdentExpr: ID '[' Expr ']'
		{
			struct IdentExpr *identExpr = (struct IdentExpr*)malloc(sizeof(struct IdentExpr));
			identExpr->id = $1;
			identExpr->expr = $3;
			$$ = identExpr;
		}
	| ID
		{
			struct IdentExpr *identExpr = (struct IdentExpr*)malloc(sizeof(struct IdentExpr));
			identExpr->id = $1;
			identExpr->expr = NULL;
			$$ = identExpr;
		}
	;
CallExpr: ID '(' ')'
		{
			struct CallExpr *callExpr = (struct CallExpr*)malloc(sizeof(struct CallExpr));
			callExpr->id = $1;
			callExpr->arg = NULL;
			$$ = callExpr;
		}
	| ID '(' ArgList ')'
		{
			struct CallExpr *callExpr = (struct CallExpr*)malloc(sizeof(struct CallExpr));
			callExpr->id = $1;
			callExpr->arg = $3;
			$$ = callExpr;
		}
	;

ArgList: Expr
		{
			$$ = $1;
		}
	| ArgList ',' Expr
		{
			struct Arg *arg = (struct Arg*)malloc(sizeof(struct Arg));
			arg->expr = $3;
			arg->prev = $1;
			$$ = arg;
		}
	;

UnOp: UNOP
		{
			struct UnOp *unOp = (struct UnOp*)malloc(sizeof(struct UnOp));
			unOp->e = eNegative;
			$$ = unOp;
		}
	;
AddiOp: ADDIOP
		{
			struct AddiOp *addiOp = (struct AddiOp*)malloc(sizeof(struct AddiOp));
			addiOp->e = ((strcmp($1, "+")==0)?ePlus:eMinus);
			$$ = addiOp;
		}
	;
MultOp: MULTOP
		{
			struct MultOp *multOp = (struct MultOp*)malloc(sizeof(struct MultOp));
			multOp->e = ((strcmp($1, "*")==0)?eMul:eDiv);
			$$ = multOp;
		}
	;
RelaOp: RELAOP
		{
			struct RelaOp *relaOp = (struct RelaOp*)malloc(sizeof(struct RelaOp));
			if (strlen($1)==2) {
				relaOp->e = ((strcmp($1, ">=")==0)?eGE:eLE);
			} else {
				relaOp->e = ((strcmp($1, ">")==0)?eGT:eLT);
			}
			$$ = relaOp;
		}
	;
EqltOp: EQLTOP
		{
			struct EqltOp *eqltOp = (struct EqltOp*)malloc(sizeof(struct EqltOp));
			eqltOp->e = ((strcmp($1, "==")==0)?eEQ:eNE);
			$$ = eqltOp;
		}
	;


%%
	/* c code */
void yyerror(char *s) {
	// fprintf(stderr, "error: %s\n", s);
	fprintf(stderr, "%d: error: '%s' at '%s', yylval=%u\n", yylineno, s, yytext, yylval);
}