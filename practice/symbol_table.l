%{
#include<stdio.h>
#include<string.h>

struct table{
    char name[10];
    char scope[10];
    char type[10];
};

struct table symboltable[50];

char type[10]="unknown";
char scope[10]="global";
char name[10];

int keywords=0,identifiers=0,constants=0,operators=0;

int defined(char *name, char *scope){
    for(int i=0;i<identifiers;i++){
        if(strcmp(symboltable[i].name,name)==0 && strcmp(symboltable[i].scope,scope)==0) return 1;
    }

    strcpy(symboltable[identifiers].name,name);
    strcpy(symboltable[identifiers].type,type);
    strcpy(symboltable[identifiers].scope,scope);
    identifiers++;
    return 0;
}
%}

%%
int|float|char|double           {
    strcpy(type,yytext);
}
[a-zA-Z_][a-zA-Z0-9_]*          { 
    if(defined(yytext,scope)) printf("Error: %s already defined in %s\n",name, scope);
    printf("Identifier: %s\n",yytext);
    }
"{"                             {
    strcpy(scope,"local");
}
"}"                             {
    strcpy(scope,"global");
}
%%

int main(){
    yylex();
    printf("%-10s %-10s %-10s\n\n","Name","Type","Scope");
    for(int i=0;i<identifiers;i++){
        printf("%-10s %-10s %-10s\n",symboltable[i].name,symboltable[i].type,symboltable[i].scope);
    }
    return 0;
}

int yywrap(){
    return 1;
}