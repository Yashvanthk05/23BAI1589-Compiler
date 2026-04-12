%{
#include<stdio.h>
%}

%%
"#".*                           { printf("Header file: %s\n",yytext); }
[a-zA-Z_][a-zA-Z0-9_]*          { printf("Identifier: %s\n",yytext); }
([0-9]+|[0-9]+\.[0-9]+)         { printf("Numbers: %s\n", yytext); }
[+\-*/%]                        { printf("Operators: %s\n", yytext); }
[(){}[\];,]                     { printf("Separators: %s\n", yytext); }
.|\n                            {}
%%

int main(){
    yylex();
    return 0;
}

int yywrap(){
    return 1;
}