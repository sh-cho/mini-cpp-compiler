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
	/* patterns & actions */
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