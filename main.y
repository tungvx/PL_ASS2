%{
#include <stdio.h>
#include "dict.h"    
#include "gc.h"
    
extern int yylex();
dict *d;
%}

%union{
    char *str;
}

%token<str> VARNAME WORD TEXT SEPERATOR ENDLINE EOI CONTENT EQUAL

%%
input: rules SEPERATOR main_text EOI
rules: 
     | VARNAME EQUAL CONTENT ENDLINE rules	{add(d, $1, $3);}
main_text: 
	 | word main_text
word: WORD {printf("%s", $1);}
    | VARNAME {char *content = find(d, $1); if (content == NULL) content = $1; printf("%s", content);} 
    | ENDLINE {printf("\n");}
%%

int main(int argc, char *argv){
    GC_INIT();
    d = GC_MALLOC(sizeof(dict));
    yyparse();
    return 0;
}
