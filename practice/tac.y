%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

void yyerror(char *s){
    fprintf(stderr,"%s\n",s);
}

int yylex();

int temp_cnt = 0;
char* temp_gen(char op1[], char op[], char op2[]){
    if(strcmp(op,"=")==0){
        printf("t%d = %s\n",temp_cnt,op1);
    }else{
        printf("t%d = %s %s %s\n",temp_cnt,op1,op,op2);
    }
    temp_cnt++;
    char *buf=malloc(50);
    sprintf(buf,"t%d",temp_cnt-1);
    return buf;
}
%}

%union {
    char *s;
}

%token END
%token <s> ID
%type <s> expr

%left '+' '-'
%left '*' '/'

%%
program:    program stmt
        |
        ;
stmt:   ID '=' expr ';' '\n'       { printf("%s = %s\n",$1,$3); }
    |   ID '=' expr ';'            { printf("%s = %s\n",$1,$3); }
    |   END                          { return 0; } 
expr:       expr '+' expr       {
            $$ = temp_gen($1,"+",$3);
}
    |       expr '-' expr       {
            $$ = temp_gen($1,"-",$3);
}
    |       expr '*' expr       {
            $$ = temp_gen($1,"*",$3);
}
    |       expr '/' expr       {
            $$ = temp_gen($1,"/",$3);
}
    |       '(' expr ')'        {
            $$ = $2;
    }
    |       ID                  {
        $$ = $1;
    }
    ;
%%

int main(){
    printf("Enter program:\n");
    yyparse();
    return 0;
}