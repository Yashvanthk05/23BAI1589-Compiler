%{
#include<stdio.h>
#include<string.h>

typedef struct symboltable {
    char name[10];
    char type[10];
} table;

table symtable[10];
int id=0;

char curtype[10];

int yylex();
void yyerror(char *s){
    fprintf(stderr,"%s\n",s);
}

int checkdifftype(char *name){
    for(int i=0;i<id;i++){
        if(strcmp(symtable[i].name,name)==0) return 1;
    }
    return 0;
}

int checkdeclared(char *name, char *type){
    for(int i=0;i<id;i++){
        if(strcmp(symtable[i].name,name)==0 && strcmp(symtable[i].type,type)==0) return 1;
    }
    return 0;
}

void insert(char *name, char *type){
    if(checkdeclared(name,type)){
        printf("Identifier %s with Type %s already declared\n",name,type);
        return;
    }
    if(checkdifftype(name)){
        printf("Identifier %s with Different type already declared\n",name);
        return;
    }
    strcpy(symtable[id].name,name);
    strcpy(symtable[id].type,type);
    printf("Identifier %s with Type %s is declared\n",name,type);
    id++;
}

%}

%union {
    char *s;
}

%token END
%token <s> ID TYPE

%%
input:      input line 
     |      line
     ;
line:       declare ';' '\n'
    |       END         { return 0; }
    ;
declare:    TYPE {
        strcpy(curtype,$1);
    } iden
       ;
iden:   iden ',' ID             { insert($3, curtype); }
    |   ID                      { insert($1, curtype); }
%%

int main(){
    printf("Enter the declarations (type END to stop):\n");
    yyparse();
    return 0;
}