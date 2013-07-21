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

%%
"\n"		printf("Endline\n");
{CAPITALS}+ 	{printf("Varname ");}
"="{NORMAL}+	{printf("Content ");}
"%""\n" 	{printf("Sep ");}
{NONCAPITALS}+	{printf("normal ");}
<<EOF>>		{return EOI;}
.		{yyerror("Illigal Characters"); exit(1);}
%%

int main(){
    yylex();
    return 0;
}
