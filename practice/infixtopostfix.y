%{
#include<stdio.h>
#include<stdlib.h>

void yyerror(char *s){
    fprintf(stderr, "%s\n", s);
}

int yylex();
%}

%union {
    char* s;
}

%token <s> IDENTIFIER
%token END
%type <s> expr

%left '+' '-'
%left '*' '/'

%%
program: program stmt
        |
        ;
stmt:   expr '\n'  { printf("Converted: %s\n",$1); }
    |   END        { return 0; }
    ;
expr:   expr '+' expr {
        char *buf = malloc(50);
        sprintf(buf,"%s %s +",$1,$3);
        $$=buf;
    }
    |   expr '-' expr {
        char *buf = malloc(50);
        sprintf(buf,"%s %s -",$1,$3);
        $$=buf;
    }
    |   expr '/' expr {
        char *buf = malloc(50);
        sprintf(buf,"%s %s /",$1,$3);
        $$=buf;
    }
    |   expr '*' expr {
        char *buf = malloc(50);
        sprintf(buf,"%s %s *",$1,$3);
        $$=buf;
    }
    |   '(' expr ')'  { $$=$2; }
    |   IDENTIFIER  { $$=$1; }
%%

int main(){
    yyparse();
    return 0;
}