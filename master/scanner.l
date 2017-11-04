	/* declarations */
%{
	#include "parser.tab.h"
%}
	/* patterns */
unop		"-"
addiop		[\+\-]
multop		[\*\/]
relaop		("<="|">="|"<"|">")
eqltop		("=="|"!=")
id			[A-Za-z_][A-Za-z0-9_]*
intnum		[0-9]+
floatnum	[0-9]+.[0-9]+
space		[ \t\r\n]
special		[\(\)\{\}\[\]\,\.\=\;\:]


%%

	/*--------------------------------------------------------------------
	 * 
	 * patterns & actions
	 * 
	 *------------------------------------------------------------------*/
{unop} {
	return UNOP;
}

{addiop} {
	//TODO
	yylval.addiop = strdup(yytext);
	return ADDIOP;
}

{multop} {
	//TODO
	yylval.addiop = strdup(yytext);
	return MULTOP;
}

{relaop} {
	//TODO
	yylval.addiop = strdup(yytext);
	return RELAOP;
}

{eqltop} {
	//TODO
	yylval.addiop = strdup(yytext);
	return EQLTOP;
}


	/*--------------------------------------------------------------------
	 * 
	 * keywords
	 * 
	 *------------------------------------------------------------------*/
class {
	return CLASS;
}

do {
	return DO;
}

else {
	return ELSE;
}

float {
	return FLOATTYPE;
}

for {
	return FOR;
}

int {
	return INTTYPE;
}

main {
	return MAIN;
}

private {
	return PRIVATE;
}

public {
	return PUBLIC;
}

return {
	return RETURN;
}

while {
	return WHILE;
}

	/*--------------------------------------------------------------------
	 * 
	 * else
	 * 
	 *------------------------------------------------------------------*/
{id} {
	yylval.id = strdup(yytext);
	return ID;
}

{intnum} {
	//TODO
	yylval.intnum = atoi(yytext);
	return INTNUM;
}

{floatnum} {
	//TODO
	yylval.floatnum = atof(yytext);
	return FLOATNUM;
}

{space} {
	break;
}

{special} {
	return yytext[0];
}


%%
	/* c code */