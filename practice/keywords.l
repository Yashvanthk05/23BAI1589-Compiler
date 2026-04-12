%{
#include<stdio.h>

int keywords = 0;
%}

%%
int|float|char|printf|return|if|else|while          { printf("Keyword: %s\n",yytext); keywords++; }
.|\n                                           {}
%%

int main(int argc,char *argv[]){
    yylex();
    printf("Number of Keywords: %d\n",keywords);
    return 0;
}

int yywrap(){
    return 1;
}