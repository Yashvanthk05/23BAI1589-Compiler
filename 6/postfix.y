%{
#include<stdio.h>

void yyerror(char *s);
int yylex();
%}

%token IDENTIFIER

%left '+' '-'
%left '*' '/'

%%
line: expr '\n' { printf("\n"); return 0; }
      ;
expr: expr '+' expr { printf("+"); }
    | expr '-' expr { printf("-"); }
    | expr '*' expr { printf("*"); }
    | expr '/' expr { printf("/"); }
    | '(' expr ')'
    | IDENTIFIER { printf("%c",$1); }
    ;
%%

void yyerror(char *s){
    printf("Invalid Statement\n");
}

int main(){
    printf("Enter Infix Expression:\n");
    yyparse();
    return 0;
}

