%{
#include "y.tab.h"
%}

%%
"END"           { return END; }
[0-9]+          { yylval = atoi(yytext); return NUMBER; }
\n              { return '\n'; }
[ \t]+        {}
.               { return yytext[0]; }
%%

int yywrap(){
    return 1;
}