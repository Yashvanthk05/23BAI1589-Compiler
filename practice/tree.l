%{
#include "y.tab.h"
#include<string.h>
%}

%%
[a-zA-Z_][a-zA-Z0-9_]*|[0-9]+  { yylval.val = strdup(yytext); return ID; }
[ \t]+    {}
\n        { return '\n'; }
.   { return yytext[0]; }
%%

int yywrap(){
    return 1;
}