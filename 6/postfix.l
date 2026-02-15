%{
#include "y.tab.h"
#include<stdlib.h>
%}

%%
[a-zA-Z]    { yylval=yytext[0]; return IDENTIFIER; }
\n          return '\n';
.           return yytext[0];
%%

int yywrap(){
    return 1;
}

