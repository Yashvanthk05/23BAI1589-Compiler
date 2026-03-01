%{
#include "y.tab.h"
#include <stdlib.h>
#include <string.h>
%}

%%
[0-9]+ {
    yylval.ival = atoi(yytext);
    return NUM;
}

[a-zA-Z]+ {
    yylval.name = strdup(yytext);
    return ID;
}

[ \t\n] ;

. { return yytext[0]; }

%%

int yywrap() {
    return 1;
}