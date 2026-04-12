%{
#include "y.tab.h"
%}
%%
\n\no           { return 0; }
[A-Z]           { yylval.ch = yytext[0]; return NT;  }
[a-z#()+*]      { yylval.ch = yytext[0]; return TER; }
"="             { return EQ;      }
"|"             { return PIPE;    }
\n              { return NEWLINE; }
[ \t]           { }
%%
int yywrap(){ return 1; }