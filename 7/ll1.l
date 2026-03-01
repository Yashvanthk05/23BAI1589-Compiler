%{
#include "y.tab.h"
%}

%%
[A-Z][a-zA-Z0-9]*      { yylval.sym = yytext[0]; return NONTERM; }
[a-z()+*][a-zA-Z0-9]*  { yylval.sym = yytext[0]; return TERM; }
"->"       { return ARROW; }
"|"        { return OR; }
"#"        { yylval.sym = '#'; return EPS; }
"\n"       { return NEWLINE; }
[ \t]      {}
%%

int yywrap() {
    return 1;
}