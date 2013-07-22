%option  noyywrap
CAPITALS	[A-Z]
LOWER		[a-z]
SPACE		" "
PUNCTUATION	[':,!.?;]
NONCAPITALS 	{LOWER}|{SPACE}|{PUNCTUATION}
NORMAL		{CAPITALS}|{NONCAPITALS}

%{
#include "main.tab.h"
#include <string.h>  
void yyerror(char *s){ fprintf(stderr, "%s\n", s);}
%}

%x REALLYEND CONTENT_TOKEN

%%
"\n"		return ENDLINE;
{CAPITALS}+ 	{yylval.str = strdup(yytext); return VARNAME;}
"="		{BEGIN(CONTENT_TOKEN); return EQUAL;}
"%""\n" 	{return SEPERATOR;}
{NONCAPITALS}+	{yylval.str = strdup(yytext); return WORD;}
<CONTENT_TOKEN>{NORMAL}+	{yylval.str = strdup(yytext); BEGIN(INITIAL); return CONTENT;}
<CONTENT_TOKEN>"\n"		{BEGIN(INITIAL); return ENDLINE;}
<INITIAL><<EOF>>		{BEGIN(REALLYEND); return EOI;}
<REALLYEND><<EOF>>      { return 0; }
.		{yyerror("Illigal Characters"); exit(1);}
%%
