%option  noyywrap
CAPITALS	[A-Z]
LOWER		[a-z]
SPACE		" "
PUNCTUATION	[':,!.?;]
NONCAPITALS 	{LOWER}|{SPACE}|{PUNCTUATION}
NORMAL		{CAPITALS}|{NONCAPITALS}

%{
void yyerror(char *s){ fprintf(stderr, "%s\n", s);}
%}

%x REALLYEND CONTENT_TOKEN

%%
"\n"		printf("ENDL\n");
{CAPITALS}+ 	printf("Varname ");
"="		{printf("Equal "); BEGIN(CONTENT_TOKEN);}
"%""\n" 	{printf("Sep\n"); }
{NONCAPITALS}+	{printf("Word "); }
<CONTENT_TOKEN>{NORMAL}+	{printf("Content "); BEGIN(INITIAL);}
<CONTENT_TOKEN>"\n"		{printf("ENDL\n");}
<INITIAL><<EOF>>		{printf("EOF"); return;}
<REALLYEND><<EOF>>      { return 0; }
.		{yyerror("Illigal Characters"); exit(1);}
%%

int main(){
    yylex();
    return 0;
}
