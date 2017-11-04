	/* dec */
%{
	#include "parser.tab.h"
%}
	/* patterns */
id			[a-zA-Z_][a-zA-Z0-9_]*
intnum		[0-9]+
space		[ \t\n]+

%%

	/* keywords */
"class" { return CLASS; }
"private" { return PRIVATE; }
"int" { return INTTYPE; }

	/* patterns */
{id} {
	printf("id yytext: %s\n", yytext);
	yylval.id = strdup(yytext);
	return ID;
}

{intnum} {
	printf("intnum yytext: %s\n", yytext);
	yylval.intnum = atoi(yytext);
	return INTNUM;
}

{space} ;

	/* miscellaneous */
. { printf("Mystery character '%c'\n", *yytext); }

%%
	/* c code */