%{
#include<stdio.h>
%}

%x SINGLE_COMMENT
%x MULTI_COMMENT

%%
"//"                    { BEGIN(SINGLE_COMMENT); }
<SINGLE_COMMENT>\n      { BEGIN(INITIAL); }
<SINGLE_COMMENT>.       {}

"/*"                    { BEGIN(MULTI_COMMENT); }
<MULTI_COMMENT>"*/"\n   { BEGIN(INITIAL); }
<MULTI_COMMENT>\n       {}
<MULTI_COMMENT>.        {}

[ \t]+                  { printf(" "); }
.|\n                    { printf("%s",yytext); }
%%

int main(int argc,char *argv[]){
    if(argc>1){
        FILE *f=fopen(argv[1],"r");
        if(!f){
            printf("File not Found");
            return 1;
        }
        yyin=f;
    }
    yylex();
    printf("\n");
    return 0;
}

int yywrap(){
    return 1;
}