%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

typedef struct Node{
    char val[20];
    struct Node *left;
    struct Node *right;
}Node;

Node* newNode(char *v,Node *l,Node *r) {
    Node *newnode=(Node*)malloc(sizeof(Node));
    strcpy(newnode->val,v);
    newnode->left=l;
    newnode->right=r;
    return newnode;
}

void printTree(Node *n,char *prefix,int isLeft) {
    if (!n) return;
    printf("%s%s%s\n",prefix,isLeft?"|-":"|_ ",n->val);
    char pre[256];
    printf("%s%s",prefix,isLeft?"│":"   ");
    strcpy(pre,"");
    if (n->left || n->right){
        printTree(n->left,pre,1);
        printTree(n->right,pre,0);
    }
}

int yylex();
void yyerror(char *s){
    printf("Error\n");
}
%}

%union {
    int ival;
    char *name;
    struct Node *node;
}

%token <ival> NUM
%token <name> ID
%type <node> expr term factor start

%left '+' '-'
%left '*' '/'

%%
start: expr {
            printf("Parse Tree:\n");
            printTree($1,"",0);
        }
        ;

expr: expr'+'term { $$=newNode("+",$1,$3); }
    | expr'-'term { $$=newNode("-",$1,$3); }
    | term { $$=$1; }
    ;

term: term '*' factor { $$=newNode("*",$1,$3); }
    | term '/' factor { $$=newNode("/",$1,$3); }
    | factor { $$=$1; }
    ;

factor: '('expr')' { $$=$2; }
        | NUM {
            char temp[20];
            sprintf(temp,"%d",$1);
            $$=newNode(temp,NULL,NULL);
        }
        | ID { $$=newNode($1,NULL,NULL); }
        ;
%%

int main(){
    printf("Enter expression:\n");
    yyparse();
    return 0;
}