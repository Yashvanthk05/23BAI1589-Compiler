%{
#include<stdio.h>

int count=0;
%}

%%
int|float|double|char|long|for|do|while|if|else|void|static|return|continue|break|const|struct|union {
    printf("Keyword: %s\n",yytext);
    count++;
}
.|\n {}
%%

int main(int argc,char *argv[]){
    if(argc>1){
        FILE *f=fopen(argv[1],"r");
        if(!f){
            printf("%s File not Found\n",argv[1]);
            return 1;
        }
        yyin=f;
    }
    yylex();
    printf("Numbers of Keywords Identified: %d\n",count);
    return 0;
}

int yywrap(){
    return 1;
}



