%{
#include<stdio.h>

int lines=0,words=0,characters=0;
%}

%%
\n          { lines++; characters++; }
[ \t]+      { characters+=yyleng; }
[^ \t\n]+   { words++; characters+=yyleng; }
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
    printf("Number of Lines: %d\n",lines);
    printf("Number of Words: %d\n",words);
    printf("Number of Characters: %d\n",characters);
    return 0;
}

int yywrap(){
    return 1;
}

