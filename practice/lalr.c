#include<stdio.h>
#include<string.h>

int action[7][3] = {
    {3, 4, 0},
    {0, 0, 99},
    {3, 4, 0},
    {3, 4, 0},
    {-3, -3, -3},
    {0, 0, -1},
    {-2, -2, -2},
};

int rule_len[] = {0, 2, 2, 1};
int rule_lhs[] = {0, 0, 1, 1};

int go_to[7][2]={
    {1, 2},
    {0, 0},
    {0, 5},
    {0, 6},
    {0, 0},
    {0, 0},
    {0, 0},
};

int get_token(char ch){
    if(ch=='a') return 0;
    if(ch=='b') return 1;
    if(ch=='$') return 2;
    return -1;
}

int stk[100];
int top=-1;

void push(int s){
    stk[++top]=s;
}

int pop(){
    return stk[top--];
}

int main(){
    char input[50];
    scanf("%s",input);
    strcat(input,"$");
    int pos=0;
    push(0);
    printf("%-20s %-15s %-15s\n","Stack","Input","Action");
    while(1){
        int state=stk[top];
        int token=get_token(input[pos]);

        if(token==-1){
            printf("Invalid Token %c\n",input[pos]);
            break;
        }

        printf("[ ");
        for(int i=0;i<=top;i++) printf("%d ",stk[i]);
        printf("]");

        printf("%20s",input+pos);
        printf("             ");

        int act = action[state][token];
        if(act==99){
            printf("Input Accepted\n");
            break;
        }else if(act>0){
            printf("Shift by %d\n",act);
            push(act);
            pos++;
        }else if(act<0){
            int rule = -act;
            printf("Reduce by %d\n",rule);
            for(int i=0;i<rule_len[rule];i++) pop();
            int new_state = go_to[stk[top]][rule_lhs[rule]];
            push(new_state);
        }else{
            printf("Syntax Error\n");
            break;
        }
    }
    return 0;
}