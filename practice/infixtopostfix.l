%{
#include "y.tab.h"
#include<string.h>
%}

%%
"END"                               { return END; }
[a-zA-Z_][a-zA-Z0-9_]*|[0-9]+       { yylval.s = strdup(yytext); return IDENTIFIER;}
[ \t]+                              {}
\n                                  { return '\n'; }
.                                   { return yytext[0]; }
%%

int yywrap(){
    return 1;
}