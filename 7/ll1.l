%{
#include "y.tab.h"
%}

%%
"->"        { return ARROW; }
"|"         { return OR; }
"#"         { yylval.ch='#'; return T; }
\n          { return NL; }
[ \t]       { }
[A-Z]       { yylval.ch=yytext[0]; return NT; }
[a-z+*()$]  { yylval.ch=yytext[0]; return T; }
%%

int yywrap(){
    return 1;
}

