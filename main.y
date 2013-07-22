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

%token<str> VARNAME WORD TEXT SEPERATOR ENDLINE EOI CONTENT EQUAL
%type<str> content

%%
input: rules SEPERATOR main_text EOI
rules: 
     | VARNAME EQUAL content ENDLINE rules	{add(d, $1, $3);}
content: 		{$$ = "";}
	| CONTENT	{$$ = $1;}
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
    return 0;
}
