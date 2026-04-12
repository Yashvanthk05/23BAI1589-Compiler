%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

typedef struct Node{
    char val[10];
    struct Node *left;
    struct Node *right;
} Node;


void yyerror(char *s){
    fprintf(stderr,"%s\n",s);
}
int yylex();

Node* newnode(char *v,Node *l, Node *r){
    Node *node = (Node*)malloc(sizeof(Node));
    strcpy(node->val,v);
    node->left=l;
    node->right=r;
    return node;
}

void printTree(Node *n,char *prefix,int isLeft){
    if(!n) return;
    printf("%s",prefix);
    printf("%s%s\n",isLeft?"|-":"|_",n->val);
    char newprefix[20];
    if(isLeft) sprintf(newprefix,"%s|   ",prefix);
    else sprintf(newprefix,"%s  ",prefix);
    printTree(n->left, newprefix,1);
    printTree(n->right,newprefix,0);
}
%}

%union {
    char *val;
    struct Node *node;
}

%token <val> ID
%type <node> factor term expr

%%
start: expr '\n' {
    printf("Parse Tree:\n");
    printTree($1,"",0);
    YYACCEPT;
}
expr: expr '+' term { $$ = newnode("+",$1,$3); }
    | expr '-' term { $$ = newnode("-",$1,$3); }
    | term          { $$ = $1; }
    ;
term: term '*' factor { $$ = newnode("*",$1,$3); }
    | term '/' factor { $$ = newnode("/",$1,$3); }
    | factor          { $$ = $1; }
    ;
factor: ID         { $$ = newnode($1,NULL,NULL); }
      | '(' expr ')'    { $$ = $2; }
%%

int main(){
    printf("Enter the Expression: ");
    yyparse();
    return 0;
}