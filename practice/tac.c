#include <stdio.h>
#include <ctype.h>
#include <string.h>

#define MAX 100

char op_stack[MAX];
char val_stack[MAX][10];
int top_op = -1, top_val = -1;
int temp = 1;

int precedence(char op) {
    if(op=='+' || op=='-') return 1;
    if(op=='*' || op=='/') return 2;
    return 0;
}

void push_op(char op) {
    op_stack[++top_op] = op;
}

char pop_op() {
    return op_stack[top_op--];
}

void push_val(char *val) {
    strcpy(val_stack[++top_val], val);
}

char* pop_val() {
    return val_stack[top_val--];
}

void generate() {
    char op = pop_op();

    char op2[10], op1[10];
    strcpy(op2, pop_val());
    strcpy(op1, pop_val());

    char temp_var[10];
    sprintf(temp_var, "t%d", temp++);

    printf("%s = %s %c %s\n", temp_var, op1, op, op2);

    push_val(temp_var);
}

int main() {
    char exp[MAX], temp_str[2];
    printf("Enter expression: ");
    scanf("%s", exp);

    for(int i=0; exp[i]!='\0'; i++) {
        char ch = exp[i];

        if(isalnum(ch)) {
            temp_str[0] = ch;
            temp_str[1] = '\0';
            push_val(temp_str);
        }
        else if(ch == '(') {
            push_op(ch);
        }
        else if(ch == ')') {
            while(op_stack[top_op] != '(')
                generate();
            pop_op();
        }
        else {
            while(top_op!=-1 && precedence(op_stack[top_op]) >= precedence(ch))
                generate();
            push_op(ch);
        }
    }

    while(top_op != -1)
        generate();

    return 0;
}