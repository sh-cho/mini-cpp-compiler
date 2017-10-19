	/* declarations */
%{
	#include "parser.tab.h"
%}

id			[A-Za-z_][A-Za-z0-9_]*
intnum		[0-9]+
floatnum	[0-9]+.[0-9]+


%%
	/* patterns & actions */
{id} {
	return ID;
}

{intnum} {
	return INTNUM;
}

{floatnum} {
	return FLOATNUM;
}



%%
	/* c code */