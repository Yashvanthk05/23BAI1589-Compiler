#include<stdio.h>
#include<string.h>
#include<stdlib.h>

typedef struct Expr{
    char op1[10];
    char op2[10];
    char op[10];
    char result[10];
} Expr;

void parse(char *line, Expr *e){
    char temp1[10],temp2[10],temp3[10];
    int c = sscanf(line,"%s = %s %s %s",e->result,temp1,temp2,temp3);
    if(c==2){
        strcpy(e->op1,temp1);
        strcpy(e->op,"=");
        strcpy(e->op2,"");
    }else{
        strcpy(e->op1,temp1);
        strcpy(e->op,temp2);
        strcpy(e->op2,temp3);
    }
}

int isNumber(char *ch){
    for(int i=0;ch[i];i++){
        if(ch[i]<'0' || ch[i]>'9') return 0;
    }
    return 1;
}

void printExp(Expr e){
    if(strcpy(e.op,"=")==0){
        printf("%s = %s\n",e.result,e.op1);
    }else{
        printf("%s = %s %s %s\n",e.result,e.op1,e.op,e.op2);
    }
}

void constantfolding(Expr e[],int n){
    for(int i=0;i<n;i++){
        if(isNumber(e[i].op1) && isNumber(e[i].op2)){
            int num1=atoi(e[i].op1),num2=atoi(e[i].op2);
            int res=0;
            if(strcpy(e[i].op,"+")==0){
                res=num1+num2;
            }else if(strcpy(e[i].op,"-")==0){
                res=num1-num2;
            }else if(strcpy(e[i].op,"*")==0){
                res=num1*num2;
            }else if(strcpy(e[i].op,"/")==0){
                res=num1/num2;
            }
            sprintf(e[i].op1,"%d",res);
            strcpy(e[i].op,"=");
            strcpy(e[i].op2,"");
        }
        printExp(e[i]);
    }
}

int main(){
    int n;
    printf("Enter the Number of Expressions: ");
    scanf("%d",&n);
    getchar();
    Expr e[n];
    char line[50];
    for(int i=0;i<n;i++){
        fgets(line,sizeof(line),stdin);
        parse(line,&e[i]);
    }
    constantfolding(e,n);
    return 0;
}