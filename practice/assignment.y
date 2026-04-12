%{
#include<stdio.h>
#include<stdlib.h>

void yyerror(char *s){
    fprintf(stderr,"%s\n",s);
}

int yylex();
%}

%union {
    char *s;
}

%token <s> IDENTIFIER NUMBER OPERATOR END
%type <s> expr term
%%
program: program stmt
        |
        ;
stmt:   IDENTIFIER '=' expr ';' '\n' { printf("Valid Assignment: %s = %s\n",$1,$3); }
    |   IDENTIFIER '=' expr ';'      { printf("Valid Assignment: %s = %s\n",$1,$3); }
    |   END {return 0; }
    ;
expr:   expr OPERATOR term      { 
    char *buf=malloc(100);
    sprintf(buf, "%s %s %s", $1, $2, $3);
    $$=buf;
}
    |   term {$$ = $1;}
    ;
term:   IDENTIFIER {$$=$1;}
    |   NUMBER      {$$=$1;}
    ;
%%

int main(){
    printf("Enter an assignment:\n");
    yyparse();
    return 0;
}