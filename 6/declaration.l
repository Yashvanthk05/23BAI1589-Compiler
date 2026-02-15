%{
#include "y.tab.h"
#include<string.h>
#include<stdlib.h>
%}

%%
"int"   { return INT; }
"float" { return FLOAT; }
"char"  { return CHAR; }
[a-zA-Z][a-zA-Z0-9]* {
    yylval.str=strdup(yytext);
    return IDENTIFIER;
}
[ \t\n] ;
[;,]    { return yytext[0]; }
.       { return yytext[0]; }
%%

int yywrap(){
    return 1;
}

