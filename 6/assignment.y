%{
#include<stdio.h>

void yyerror(char *s);
int yylex();
%}

%token IDENTIFIER NUMBER OPERATOR

%%
stmt: IDENTIFIER '=' expr ';' '\n' { printf("Valid Assignment\n"); return 0; }
    | IDENTIFIER '=' expr ';' { printf("Valid Assignment\n"); return 0; }
    ;
expr: expr OPERATOR term
    | term
    ;
term: IDENTIFIER
    | NUMBER
    ;
%%

void yyerror(char *s){
    printf("Invalid Syntax\n");
}

int main(){
    printf("Enter an assignment:\n");
    yyparse();
    return 0;
}

