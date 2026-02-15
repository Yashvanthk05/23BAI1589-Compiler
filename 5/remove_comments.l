%{
#include<stdio.h>
%}

%x MULTILINE

%%
"//".*          {}
"/*"            { BEGIN(MULTILINE); }
<MULTILINE>"*/" { BEGIN(INITIAL); }
<MULTILINE>.|\n {}
.|\n            { printf("%s",yytext); }
%%

int main(int argc,char * argv[]){
    if(argc>1){
        FILE *f=fopen(argv[1],"r");
        if(!f){
            printf("%s File not found\n",argv[1]);
            return 1;
        }
        yyin=f;
    }
    yylex();
    return 0;
}

int yywrap(){
    return 1;
}


