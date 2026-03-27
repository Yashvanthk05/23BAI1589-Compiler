%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

int temp_cnt = 0;

void yyerror(char *s){
    printf("Syntax error: %s\n",s);
}
int yylex();
%}

%union {
    char* str;
}

%token <str> ID
%token PLUS MINUS MUL DIV ASSIGN LPAREN RPAREN
%type <str> E T F S

%%
S: ID ASSIGN E ';' {
    printf("%s = %s\n",$1,$3);
  }
  ;

E: E PLUS T {
        char* temp = (char*)malloc(10);
        sprintf(temp,"t%d",temp_cnt++);
        printf("%s = %s + %s\n", temp, $1, $3);
        $$ = temp;
   }
   | E MINUS T {
        char* temp = (char*)malloc(10);
        sprintf(temp,"t%d",temp_cnt++);
        printf("%s = %s - %s\n", temp, $1, $3);
        $$ = temp;
   }
   | T {
        $$ = $1;
   }
   ;

T: T MUL F {
        char* temp = (char*)malloc(10);
        sprintf(temp,"t%d",temp_cnt++);
        printf("%s = %s * %s\n", temp, $1, $3);
        $$ = temp;
   }
   | T DIV F {
        char* temp = (char*)malloc(10);
        sprintf(temp,"t%d",temp_cnt++);
        printf("%s = %s + %s\n", temp, $1, $3);
        $$ = temp;
   }
   | F {
        $$ = $1;
   }
   ;

F: LPAREN E RPAREN {
        $$ = $2;
   }
   | ID {
        $$ = $1;
   }
   ;
%%

int main(){
    printf("Enter Expression:\n");
    yyparse();
    return 0;
}