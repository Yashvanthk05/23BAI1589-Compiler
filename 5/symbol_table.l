%{
#include<stdio.h>
#include<string.h>

int keywords=0,identifiers=0,constants=0,operators=0;

struct Symbol {
    char name[20];
    char type[10];
    char scope[10];
};

struct Symbol symbol_table[50];
int symbol_count=0;
char current_scope[10]="global";
char current_type[10]="unknown";

int presentInTable(char *name,char *type,char *scope){
    for(int i=0;i<symbol_count;i++){
        if(strcmp(symbol_table[i].name,name)==0 && strcmp(symbol_table[i].scope,scope)==0) return 1;
    }
    strcpy(symbol_table[symbol_count].name,name);
    strcpy(symbol_table[symbol_count].type,type);
    strcpy(symbol_table[symbol_count].scope,scope);

    symbol_count++;
    return 0;
}
%}

%%
int|float|char {
    printf("Keyword: %s\n",yytext);
    keywords++;
    strcpy(current_type,yytext);
}

if|else|return|while|for {
    printf("Keyword: %s\n",yytext);
    keywords++;
    strcpy(current_type,"unknown");
}

\"[^\"]*\"                              {
    printf("String: %s\n",yytext);
    constants++;
}

[0-9]+(\.[0-9]+)?                       {
    printf("Constant: %s\n",yytext);
    constants++;
}

[a-zA-Z_][a-zA-Z0-9_]*                  {
    if(!presentInTable(yytext,current_type,current_scope)) identifiers++;
    printf("Identifier: %s\n",yytext);
}

"+"|"-"|"/"|"*"|"%"                     {
    printf("Operator: %s\n",yytext);
    operators++;
}

"{"                                     { strcpy(current_scope,"local"); }
"}"                                     { strcpy(current_scope,"global"); }

[ \t\n();,]                             {}
.                                       {}
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
    printf("Number of Keywords: %d\n",keywords);
    printf("Number of Identifiers: %d\n",identifiers);
    printf("Number of Constants: %d\n",constants);
    printf("Number of Operators: %d\n",operators);

    printf("\nSymbol Table:\n");
    printf("%s\t%s\t%s\t%s\n","No","Name","Type","Scope");
    for(int i=0;i<symbol_count;i++){
        printf("%d\t%s\t%s\t%s\n",i+1,symbol_table[i].name,symbol_table[i].type,symbol_table[i].scope);
    }
    return 0;
}

int yywrap(){
    return 1;
}