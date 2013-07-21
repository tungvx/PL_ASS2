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
#include <stdbool.h>    
void yyerror(char *s){ fprintf(stderr, "%s\n", s);}
bool isContent = false;
%}

%x REALLYEND CONTENT_TOKEN

%%
"\n"		printf("ENDL\n");
{CAPITALS}+ 	{if (isContent) BEGIN(CONTENT_TOKEN); else printf("Varname ");}
"="	{printf("Equal "); isContent = true;}
"%""\n" 	{printf("Seperator \n");}
{NONCAPITALS}+	{if (isContent) BEGIN(CONTENT_TOKEN); else printf("Word ");}
<CONTENT_TOKEN>{NORMAL}+	{printf("Content "); isContent = false; BEGIN(INITIAL);}
<INITIAL><<EOF>>		{BEGIN(REALLYEND); return;}
<REALLYEND><<EOF>>      { return 0; }
.		{yyerror("Illigal Characters"); exit(1);}
%%

int main(){
    yylex();
    return 0;
}
