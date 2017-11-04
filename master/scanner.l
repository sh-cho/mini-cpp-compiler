	/* declarations */
%{
	#include "parser.tab.h"
%}

	/* patterns */
unop		"-"
addiop		[+-]
multop		[*/]
relaop		("<="|">="|"<"|">")
eqltop		("=="|"!=")
asgnop		"="
id			[A-Za-z_][A-Za-z0-9_]*
intnum		[0-9]+
floatnum	[0-9]+.[0-9]+
space		[ \t\r\n]


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
	return ADDIOP;
}

{multop} {
	//TODO
	return MULTOP;
}

{relaop} {
	//TODO
	return RELAOP;
}

{eqltop} {
	//TODO
	return EQLTOP;
}

{asgnop} {
	return ASGNOP;
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
	//TODO
	return ID;
}

{intnum} {
	//TODO
	return INTNUM;
}

{floatnum} {
	//TODO
	return FLOATNUM;
}

{space} {
	break;
}



%%
	/* c code */