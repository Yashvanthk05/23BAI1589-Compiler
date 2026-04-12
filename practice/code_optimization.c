#include<stdio.h>
#include<string.h>
#include<stdlib.h>

typedef struct{
    char op1[10];
    char op2[10];
    char op[10];
    char result[10];
} Expr;

void parse(char *line, Expr *exp){
    char temp1[10], temp2[10], temp3[10];
    int c = sscanf(line, "%s = %s %s %s",exp->result,temp1, temp2, temp3);
    if(c==2){
        strcpy(exp->op,"=");
        strcpy(exp->op1,temp1);
        strcpy(exp->op2,"");
    }else{
        strcpy(exp->op1,temp1);
        strcpy(exp->op,temp2);
        strcpy(exp->op2,temp3);
    }
}

int isNumber(char *s){
    if(s==NULL || s[0]=='\0') return 0;
    for(int i=0;s[i];i++){
        if(s[i]<'0' || s[i]>'9') return 0;
    }
    return 1;
}

void printExp(Expr e){
    if(strcmp(e.op,"=")==0){
        printf("%s = %s\n",e.result,e.op1);
    }else{
        printf("%s = %s %s %s\n",e.result,e.op1,e.op,e.op2);
    }
}

void constantFolding(Expr e[], int n){
    printf("\nConstant Folding:\n");
    for(int i=0;i<n;i++){
        if(isNumber(e[i].op1) && isNumber(e[i].op2)){
            int num1=atoi(e[i].op1), num2=atoi(e[i].op2);
            if(strncmp(e[i].op,"+",1)==0){
                sprintf(e[i].op1,"%d",num1+num2);
            }else if(strncmp(e[i].op,"-",1)==0){
                sprintf(e[i].op1,"%d",num1-num2);
            }else if(strncmp(e[i].op,"*",1)==0){
                sprintf(e[i].op1,"%d",num1*num2);
            }else if(strncmp(e[i].op,"/",1)==0){
                sprintf(e[i].op1,"%d",num1/num2);
            }
            strcpy(e[i].op2,"");
            strcpy(e[i].op,"=");
        }
        printExp(e[i]);
    }
}

void commonSubexpressionElimination(Expr e[], int n){
    printf("\nCommon Subexpression Elimination:\n");
    for(int i=0;i<n;i++){
        for(int j=0;j<i;j++){
            if(strcmp(e[i].op1,e[j].op1)==0 && strcmp(e[i].op2,e[j].op2)==0 && strcmp(e[i].op,e[j].op)==0){
                strcpy(e[i].op1,e[j].result);
                strcpy(e[i].op2,"");
                strcpy(e[i].op,"=");
                break;
            }
        }
        printExp(e[i]);
    }
}

void copyPropagation(Expr e[], int n){
    printf("\nCopy Propagation:\n");
    for(int i=0;i<n;i++){
        if(strcmp(e[i].op,"=")==0){
            for(int j=i+1;j<n;j++){
                if(strcmp(e[j].result,e[i].result)==0) break;
                if(strcmp(e[j].op1,e[i].result)==0){
                    strcpy(e[j].op1,e[i].op1);
                }
                if(strcmp(e[j].op2,e[i].result)==0){
                    strcpy(e[j].op2,e[i].op1);
                }
            }
        }
    }
    for(int i=0;i<n;i++){
        printExp(e[i]);
    }
}

void algebraicSimplification(Expr e[], int n){
    printf("\nAlgebraic Simplification:\n");
    for(int i=0;i<n;i++){
        if(strcmp(e[i].op,"+")==0){
            if(strcmp(e[i].op2,"0")==0){
                strcpy(e[i].op2,"");
                strcpy(e[i].op,"=");
            }
            if(strcmp(e[i].op1,"0")==0 && strcmp(e[i].op2,"")!=0){
                strcpy(e[i].op1,e[i].op2);
                strcpy(e[i].op2,"");
                strcpy(e[i].op,"=");
            }
        }else if(strcmp(e[i].op,"*")==0){
            if(strcmp(e[i].op1,"0")==0 || strcmp(e[i].op2,"0")==0){
                strcpy(e[i].op1,"0");
                strcpy(e[i].op2,"");
                strcpy(e[i].op,"=");
            }
            if(strcmp(e[i].op1,"1")==0 && strcmp(e[i].op2,"")!=0){
                strcpy(e[i].op1,e[i].op2);
                strcpy(e[i].op2,"");
                strcpy(e[i].op,"=");
            }
            if(strcmp(e[i].op2,"1")==0){
                strcpy(e[i].op2,"");
                strcpy(e[i].op,"=");
            }
        }
        printExp(e[i]);
    }
}

void deadCodeElimination(Expr e[], int n){
    printf("\nDeadCode Elimination:\n");
    for(int i=0;i<n;i++){
        int used=0;
        for(int j=i+1;j<n;j++){
            if(strcmp(e[i].result,e[j].op1)==0 || strcmp(e[i].result,e[j].op2)==0){
                used+=1;
                break;
            }
        }
        if(used || i==n-1){
            printExp(e[i]);
        }else{
            printf("%s is eliminated\n",e[i].result);
        }
    }
}

int main(){
    int n;
    printf("Enter the Number of Expression: ");
    scanf("%d",&n);
    getchar();
    char line[50];
    Expr e[n];
    for(int i=0;i<n;i++){
        fgets(line,sizeof(line),stdin);
        parse(line, &e[i]);
    }
    constantFolding(e,n);
    commonSubexpressionElimination(e,n);
    copyPropagation(e,n);
    algebraicSimplification(e,n);
    deadCodeElimination(e,n);
    return 0;
}