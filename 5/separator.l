%{
#include<stdio.h>

int identifiers=0,numbers=0,operators=0,separators=0;
%}

%%
[a-zA-Z_][a-zA-Z0-9_]*              { printf("Identifier: %s\n",yytext); }
([0-9]+\.[0-9]+|[0-9]+)             { printf("Number: %s\n",yytext); }
"+"|"-"|"/"|"*"|"%"|"^"             { printf("Operator: %s\n",yytext); }
"("|")"|"{"|"}"|"["|"]"|";"|","     { printf("Separator: %s\n",yytext); }
[ \t\n]+                            {}
.                                   {}
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
    return 0;
}

int yywrap(){
    return 1;
}



