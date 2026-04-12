%{
#include<stdio.h>    

int lines=0,words=0,characters=0;
%}

%%
\n          { lines++; characters++; }
[ \t]+      { characters+=yyleng; }
[^ \t\n]+   { words++; characters+=yyleng; }
%%

int main(int argc, char *argv[]){
    if(argc>1){
        FILE *fp=fopen(argv[1],"r");
        if(!fp){
            printf("File not found");
            return 0;
        }
        yyin = fp;
    }
    yylex();
    printf("Number of Lines: %d\n",lines);
    printf("Number of Characters: %d\n",characters);
    printf("Number of Words: %d\n",words);
}

int yywrap(){
    return 1;
}