%{
#include<stdio.h>
#include<stdlib.h>

void yyerror(char *s);
int yylex();
%}

%token NUMBER

%left '+' '-'
%left '*' '/'

%%
input: exp '\n' { printf("Result: %d\n",$1); return 0; }
       ;
exp : exp '+' exp { $$=$1+$3; }
    | exp '-' exp { $$=$1-$3; }
    | exp '*' exp { $$=$1*$3; }
    | exp '/' exp { $$=$1/$3; }
    | '('exp')' { $$=$2; }
    | NUMBER { $$=$1; }
    ;
%%

void yyerror(char *s){
    fprintf(stderr,"%s\n",s);
}

int main(){
    printf("Enter expression:\n");
    yyparse();
    return 0;
}

