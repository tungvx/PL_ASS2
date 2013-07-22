%{
#include <stdio.h>
#include "dict.h"    
#include "gc.h"
    
extern int yylex();
extern FILE * yyin;
dict *d;
%}

%union{
    char *str;
}

%token<str> VARNAME WORD TEXT SEPERATOR ENDLINE EOI EQUAL
%type<str> content

%%
input: rules SEPERATOR main_text EOI
rules: 
     | rules VARNAME EQUAL content ENDLINE	{add(d, $2, $4);}
content: 		{$$ = "";}
	| WORD content	{$$ = GC_MALLOC(sizeof(char) * (strlen($1) + strlen($2) + 1)); strcpy($$, $1); strcat($$, $2);}
	| VARNAME content {char* con = find(d, $1); if (con == NULL) con = $1; else con = strdup(con); $$ = GC_MALLOC(sizeof(char) * (strlen(con) + strlen($2) + 1)); strcpy($$, con);strcat($$, $2);}
main_text: 
	 | word main_text
word: WORD {printf("%s", $1);}
    | VARNAME {char *content = find(d, $1); if (content == NULL) content = $1; printf("%s", content);} 
    | ENDLINE {printf("\n");}
%%

int main(int argc, char *argv[]){
    if (argc == 2){
	yyin = fopen(argv[1], "r");
	if (yyin == NULL) {
	    printf("File does not exist\n");
	    return 1;
	}
    } else {
	printf("We need the file name!\n");
	return 1;
    }
    GC_INIT();
    d = GC_MALLOC(sizeof(dict));
    yyparse();
    fclose(yyin);
    return 0;
}
