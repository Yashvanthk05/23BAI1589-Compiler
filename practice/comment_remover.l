%{
#include<stdio.h>    
%}

%x MULTILINE

%%
"//".*\n                  {}
"/*"                    { BEGIN(MULTILINE); }
<MULTILINE>.|\n         {}
<MULTILINE>"*/"         { BEGIN(INITIAL); }
.|\n                    { printf("%s",yytext); }
%%

int main(){
    yylex();
    printf("\n");
    return 0;
}

int yywrap(){
    return 1;
}