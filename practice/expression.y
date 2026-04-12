%{
#include<stdio.h>

void yyerror(char *s){
    fprintf(stderr, "%s\n",s);
}

int yylex();
%}

%token NUMBER END

%left '+' '-'
%left '*' '/'

%%
program: program stmt
        |
        ;
stmt: expr '\n' { printf("Result: %d\n",$1); }
    | expr { printf("Result: %d\n",$1); }
    | END   { return 0; }
expr:   expr '+' expr { $$ = $1 + $3; }
    |   expr '-' expr { $$ = $1 - $3; }
    |   expr '*' expr { $$ = $1 * $3; }
    |   expr '/' expr { $$ = $1 / $3; }
    |   '(' expr ')'  { $$ = $2; }
    |   NUMBER        { $$ = $1; }
    ;
%%

int main(){
    printf("Enter arithmetic expression: ");
    yyparse();
    return 0;
}