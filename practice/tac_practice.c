#include<stdio.h>
#include<string.h>
#include<ctype.h>

#define MAX 100

char op_stk[MAX],val_stk[MAX][10];
int top_op=-1,top_val=-1;
int temp=0;

int precedence(char ch){
    if(ch=='*' || ch == '/') return 2;
    else if(ch=='+' || ch=='-') return 1;
    return 0;
}

void push_val(char *s){
    strcpy(val_stk[++top_val],s);
}

char* pop_val(){
    return val_stk[top_val--];
}

void push_op(char ch){
    op_stk[++top_op]=ch;
}

char pop_op(){
    return op_stk[top_op--];
}

void generate(){
    char op1[10],op2[10];
    strcpy(op2,val_stk[top_val--]);
    strcpy(op1,val_stk[top_val--]);
    char buf[10];
    sprintf(buf,"t%d",temp);
    printf("%s = %s %c %s\n",buf,op1,op_stk[top_op--],op2);
    temp++;
    push_val(buf);
}

int isoperator(char ch){
    char operators[] = "+-/*%";
    int n=sizeof(operators);
    for(int i=0;i<n;i++){
        if(operators[i]==ch) return 1;
    }
    return 0;
}

int main(){
    char e[50],buffer[50];
    int i=0;
    printf("Enter Expression:");
    scanf("%s",e);
    while(e[i]!='\0'){
        if(isalnum(e[i]) || e[i]=='_'){
            int j=0;
            while(isalnum(e[i]) || e[i]=='_'){
                buffer[j++]=e[i++];
            }
            buffer[j]='\0';
            push_val(buffer);
            continue;
        }else if(e[i]=='('){
            push_op(e[i]);
        }else if(e[i]==')'){
            while(top_op!=-1 && op_stk[top_op]!='(') generate();
            pop_op();
        }else if(isoperator(e[i])){
            while(top_op!=-1 && precedence(op_stk[top_op])>=precedence(e[i])) generate();
            push_op(e[i]);
        }
        i++;
    }
    while(top_op!=-1) generate();
    return 0;
}