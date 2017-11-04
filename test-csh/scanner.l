	/* dec */
%{
	#include "parser.tab.h"
%}
	/* patterns */
id			[a-zA-Z_][a-zA-Z0-9_]*
intnum		[0-9]+
space		[ \t\r\n]+

%%

	/* keywords */
"class" { return CLASS; }

"int" { return INTTYPE; }

	/* patterns */
{id} {
	yylval.id = strdup(yytext);
	return ID;
}

{intnum} {
	yylval.intnum = atoi(yytext);
	return INTNUM;
}

{space} ;

	/* miscellaneous */
. { printf("Mystery character '%c'\n", *yytext); }

%%
	/* c code */