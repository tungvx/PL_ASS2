%option  noyywrap
CAPITALS	[A-Z]
LOWER		[a-z]
SPACE		" "
PUNCTUATION	[':,!.?;]
NORMAL 		{CAPITALS}|{LOWER}|{SPACE}|{PUNCTUATION}

%{
#include "main.tab.h"
#include <string.h>    
void yyerror(char *s){ fprintf(stderr, "%s\n", s);}
%}

%%
"\n"		return ENDLINE;
{CAPITALS}+ 	{printf("%s\n", yytext);yylval.str = yytext; return VARNAME;}
"="		return EQUAL;
"%""\n" 	{return SEPERATOR;}
{NORMAL}+	{yylval.str = yytext; return WORD;}
<<EOF>>		{return EOI;}
.		{yyerror("Illigal Characters"); exit(1);}
%%
