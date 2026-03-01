%{
#include<stdio.h>

void yyerror(char *s);
int yylex();
int errors=0
%}

%token TYPE IDENTIFIER NUMBER
%token IF ELSE WHILE RETURN
%token EQ NE LE GE

%left EQ NE
%left '<' '>' LE GE
%left '+' '-'
%left '*' '/'
%%

program: statement_list { if(!errors) printf("Syntax is Correct\n"); }
         ;
statement_list: statement_list statement
                | statement
                ;
statement:  TYPE IDENTIFIER ';' { printf("Declaration OK\n"); }
            | TYPE IDENTIFIER '=' expression ';'    { printf("Decl + Init OK\n"); }
            | IDENTIFIER '=' expression ';' { printf("Assignment OK\n"); }
            | IF '(' expression ')' statement   { printf("If-stmt OK\n"); }
            | IF '(' expression ')' statement
              ELSE statement    { printf("If-else OK\n"); }
            | WHILE '(' expression ')' statement    { printf("While-stmt OK\n"); }
            | RETURN expression ';' { printf("Return OK\n"); }
            | '{' statement_list '}'
            ;
expression: expression '+' expression
            | expression '-' expression
            | expression '*' expression
            | expression '/' expression
            | expression EQ expression
            | expression NE expression
            | expression '<' expression
            | expression '>' expression
            | expression LE expression
            | expression GE expression
            | '(' expression ')'
            | IDENTIFIER
            | NUMBER
            ;
%%

void yyerror(char *s){
    fprintf(stderr,"Error: %s\n",s);
    errors++;
}

int main(int argc,char *argv[]){
    if(argc>1){
        FILE *f=fopen(argv[1],"r");
        if(!f){
            printf("File not found");
            return 1;
        }
        yyin=f;
    }
    yyparse();
    return 0;
}