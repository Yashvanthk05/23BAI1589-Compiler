%{
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

void yyerror(char *s);
int yylex();

struct symbolTable{
    char name[50];
    char type[20];
} symbol_table[100];

int symbol_count=0;

char *current_type;

int lookup(char *name){
    for(int i=0;i<symbol_count;i++){
        if(strcmp(symbol_table[i].name,name)==0) return i;
    }
    return -1;
}

void insert(char *name,char *type){
    strcpy(symbol_table[symbol_count].name,name);
    strcpy(symbol_table[symbol_count].type,type);
    symbol_count++;
}

void addToTable(char *name,char *type){
    int idx=lookup(name);
    if(idx!=-1){
        printf("Variable %s is already Declared as %s\n",name,symbol_table[idx].type);
        return;
    }
    insert(name,type);
    printf("Variable Declared %s of type %s\n",name,type);
}

void printSymbolTable(){
    printf("Symbol Table\n");
    printf("No\tName\tType\n");
    for(int i=0;i<symbol_count;i++){
        printf("%d\t%s\t%s\n",i+1,symbol_table[i].name,symbol_table[i].type);
    }
}
%}

%union {
    char* str;
}

%token <str> IDENTIFIER
%token INT FLOAT CHAR

%%
program: declaration_list '\n'
       | declaration_list
         ;
declaration_list: declaration
                | declaration_list declaration
                  ;
declaration: type var_list ';'
             ;
type: INT { current_type="int"; }
    | FLOAT { current_type="float"; }
    | CHAR { current_type="char"; }
    ;
var_list: IDENTIFIER { addToTable($1,current_type); }
        | var_list ',' IDENTIFIER { addToTable($3,current_type); }
        ;
%%

void yyerror(char *s){
    fprintf(stderr,"Syntax Error: %s\n",s);
}

int main(){
    printf("Enter declarations:\n");
    int rc=yyparse();
    if(rc==0){
        printSymbolTable();
    }
    return 0;
}


