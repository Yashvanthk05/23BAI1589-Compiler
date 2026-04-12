%{
#include "y.tab.h"
%}

%%
"END"        { return END; }
[A-Z]       { yylval.ch = yytext[0]; return NT; }
[a-z+*()#]   { yylval.ch = yytext[0]; return T; }
"="         { return EQ; }
\n          { return NEWLINE; }
"|"         { return PIPE; }
[ \t]       {}
%%

int yywrap(){
    return 1;
}