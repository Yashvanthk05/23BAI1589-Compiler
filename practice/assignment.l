%{
#include "y.tab.h"
#include<string.h> 
%}

%%
"END"                               { return END; }
[a-zA-Z_][a-zA-Z0-9_]*              { yylval.s = strdup(yytext); return IDENTIFIER; }
[0-9]+                              { yylval.s = strdup(yytext); return NUMBER; }
[+\-*/%]                            { yylval.s = strdup(yytext); return OPERATOR; }
\n                                  { return '\n'; }
"="                                 { return '='; }
";"                                 { return ';'; }
[ \t]+                              { }
.                                   { return yytext[0]; }
%%

int yywrap(){
    return 1;
}