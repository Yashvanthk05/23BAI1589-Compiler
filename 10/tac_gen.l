%{
#include "y.tab.h"
#include<string.h>
%}

%%
[a-zA-Z]+       { yylval.str = strdup(yytext); return ID; }
"+"             { return PLUS; }
"-"             { return MINUS; }
"*"             { return MUL; }
"/"             { return DIV; }
"="             { return ASSIGN; }
"("             { return LPAREN; }
")"             { return RPAREN; }
";"             { return ';';}
[ \t\n]+        {}
.               { return yytext[0]; }
%%

int yywrap(){
    return 1;
}

