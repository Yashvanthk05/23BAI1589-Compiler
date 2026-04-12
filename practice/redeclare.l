%{
#include "y.tab.h"
#include<string.h>
%}

%%
"END"                       { return END; }
int|float|char|double       { yylval.s = strdup(yytext); return TYPE; }
[a-zA-Z_][a-zA-Z0-9_]*      { yylval.s = strdup(yytext); return ID; }
[ \t]+                      { }
\n                          { return '\n'; }
.                           { return yytext[0]; }
%%

int yywrap(){
    return 1;
}