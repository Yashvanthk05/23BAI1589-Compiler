%{
#include "y.tab.h"
#include<string.h>

int yyeror(char *s);
%}

%%
"int"|"float"|"char"        { return TYPE; }
"if"                        { return IF; }
"while"                     { return WHILE; }
"return"                    { return RETURN; }
"else"                      { return ELSE; }
[a-zA-Z_][a-zA-Z0-9_]*      { return IDENTIFIER; }
[0-9]+(\.[0-9]+)?           { return NUMBER; }
"=="                        { return EQ; }
"!="                        { return NE; }
"<="                        { return LE; }
">="                        { return GE; }
[-+*/=<>(){};]              { return yytext[0]; }
[ \t\n]+                    {}
"//".*                      {}
.                           { printf("Unknown: %s\n",yytext); }
%%

int yywrap(){
    return 1;
}