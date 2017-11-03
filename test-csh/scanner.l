	/* dec */
%{
	#include "parser.tab.h"
%}
	/* patterns */
id			[a-zA-Z_][a-zA-Z0-9_]*
intnum		[0-9]+
space		[ \t\r\n]

%%
{id} {
	yylval.id = strdup(yytext);
	return ID;
}

{intnum} {
	yylval.intnum = atoi(yytext);
	return INTNUM;
}

{space} {
	break;
}

	/* keywords */
class { return CLASS; }
private { return PRIVATE; }
public { return PUBLIC; }
int { return INT; }

%%
	/* c code */