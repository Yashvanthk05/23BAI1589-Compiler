#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define MAX_PROD 20
#define MAX_ITEMS 200
#define MAX_STATES 100
#define MAX_SYM 20
#define MAX_COL 50
#define STACK 100

typedef struct{
    char lhs;
    char rhs[MAX_SYM];
    int len;
}Prod;

typedef struct{
    int prod;
    int dot;
}Item;

typedef struct{
    Item items[MAX_ITEMS];
    int n;
}State;

typedef struct{
    char type;
    int val;
}Entry;

Prod prods[MAX_PROD];
State states[MAX_STATES];

Entry action_table[MAX_STATES][MAX_COL];
int goto_table[MAX_STATES][MAX_COL];

char follow[256][MAX_SYM];
char col_sym[MAX_COL];

int num_prod,num_states=0,num_cols=0;

int isTerminal(char c){
    if(c>='A'&&c<='Z') return 0;
    return 1;
}

int isNonTerminal(char c){
    if(c>='A'&&c<='Z') return 1;
    return 0;
}

void addFollow(char nt,char t){
    if(!strchr(follow[(int)nt],t)){
        int l=strlen(follow[(int)nt]);
        follow[(int)nt][l]=t;
        follow[(int)nt][l+1]='\0';
    }
}

int first(const char *s,char *out){
    if(s[0]=='\0') return 1;
    char c=s[0];
    if(isTerminal(c)){
        if(!strchr(out,c)){
            int l=strlen(out);
            out[l]=c;
            out[l+1]='\0';
        }
        return 0;
    }
    int nullable=0;
    for(int i=0;i<num_prod;i++)
        if(prods[i].lhs==c)
            nullable|=first(prods[i].rhs,out);
    if(nullable)
        nullable=first(s+1,out);
    return nullable;
}

void computeFollow(){
    memset(follow,0,sizeof(follow));
    addFollow(prods[0].lhs,'$');
    int change=1;
    while(change){
        change=0;
        for(int p=0;p<num_prod;p++){
            char A=prods[p].lhs;
            for(int i=0;i<prods[p].len;i++){
                char B=prods[p].rhs[i];
                if(!isNonTerminal(B)) continue;
                char rest[MAX_SYM]="";
                strcpy(rest,prods[p].rhs+i+1);
                char firstSet[MAX_SYM]="";
                int nullable=first(rest,firstSet);
                for(int k=0;firstSet[k];k++)
                    if(!strchr(follow[(int)B],firstSet[k])){
                        addFollow(B,firstSet[k]);
                        change=1;
                    }
                if(nullable)
                    for(int k=0;follow[(int)A][k];k++)
                        if(!strchr(follow[(int)B],follow[(int)A][k])){
                            addFollow(B,follow[(int)A][k]);
                            change=1;
                        }
            }
        }
    }
}

int sameItem(Item a,Item b){
    return a.prod==b.prod&&a.dot==b.dot;
}

int hasItem(State *st,Item it){
    for(int i=0;i<st->n;i++)
        if(sameItem(st->items[i],it))
            return 1;
    return 0;
}

void addItem(State *st,Item it){
    if(!hasItem(st,it))
        st->items[st->n++]=it;
}

void closure(State *st){
    int change=1;
    while(change){
        change=0;
        for(int i=0;i<st->n;i++){
            Item it=st->items[i];
            Prod *p=&prods[it.prod];
            if(it.dot>=p->len) continue;
            char sym=p->rhs[it.dot];
            if(!isNonTerminal(sym)) continue;
            for(int j=0;j<num_prod;j++){
                if(prods[j].lhs==sym){
                    Item newItem={j,0};
                    if(!hasItem(st,newItem)){
                        addItem(st,newItem);
                        change=1;
                    }
                }
            }
        }
    }
}

int equalState(State *a,State *b){
    if(a->n!=b->n) return 0;

    for(int i=0;i<a->n;i++)
        if(!hasItem(b,a->items[i]))
            return 0;

    return 1;
}

int gotoState(int s,char sym){
    State newState;
    memset(&newState,0,sizeof(newState));
    for(int i=0;i<states[s].n;i++){
        Item it=states[s].items[i];
        Prod *p=&prods[it.prod];
        if(it.dot<p->len&&p->rhs[it.dot]==sym){
            Item moved={it.prod,it.dot+1};
            addItem(&newState,moved);
        }
    }
    if(newState.n==0) return -1;
    closure(&newState);

    for(int i=0;i<num_states;i++)
        if(equalState(&states[i],&newState))
            return i;

    states[num_states]=newState;
    return num_states++;
}

void buildStates(){
    Item start={0,0};
    states[0].n=0;
    addItem(&states[0],start);
    closure(&states[0]);
    num_states=1;
    int done=0;
    while(done<num_states){
        char symbols[20]="";
        for(int i=0;i<states[done].n;i++){
            Item it=states[done].items[i];
            Prod *p=&prods[it.prod];
            if(it.dot<p->len){
                char c=p->rhs[it.dot];
                if(!strchr(symbols,c)){
                    int l=strlen(symbols);
                    symbols[l]=c;
                    symbols[l+1]='\0';
                }
            }
        }
        for(int i=0;symbols[i];i++)
            gotoState(done,symbols[i]);
        done++;
    }
}

void buildColumns(){
    num_cols=0;
    for(int i=0;i<num_prod;i++){
        for(int j=0;j<prods[i].len;j++){
            char c=prods[i].rhs[j];
            if(!strchr(col_sym,c))
                col_sym[num_cols++]=c;
        }
        if(!strchr(col_sym,prods[i].lhs))
            col_sym[num_cols++]=prods[i].lhs;
    }

    col_sym[num_cols++]='$';
}

void buildTable(){
    for(int i=0;i<num_states;i++)
        for(int j=0;j<num_cols;j++){
            action_table[i][j].type='e';
            goto_table[i][j]=-1;
        }
    for(int s=0;s<num_states;s++){
        for(int i=0;i<states[s].n;i++){
            Item it=states[s].items[i];
            Prod *p=&prods[it.prod];
            if(it.dot<p->len){
                char a=p->rhs[it.dot];
                int ns=gotoState(s,a);
                for(int c=0;c<num_cols;c++)
                    if(col_sym[c]==a){
                        if(isTerminal(a)){
                            action_table[s][c].type='s';
                            action_table[s][c].val=ns;
                        }
                        else
                            goto_table[s][c]=ns;
                    }
            }
            else{
                if(it.prod==0){
                    for(int c=0;c<num_cols;c++)
                        if(col_sym[c]=='$')
                            action_table[s][c].type='a';
                }
                else{
                    char A=p->lhs;
                    for(int k=0;follow[(int)A][k];k++){
                        char a=follow[(int)A][k];
                        for(int c=0;c<num_cols;c++)
                            if(col_sym[c]==a){
                                action_table[s][c].type='r';
                                action_table[s][c].val=it.prod;
                            }
                    }
                }
            }
        }
    }
}

void printItemSets(){
    printf("\nITEM SETS:\n");
    for(int s=0;s<num_states;s++){
        printf("\nI%d:\n",s);
        for(int i=0;i<states[s].n;i++){
            Item it=states[s].items[i];
            Prod *p=&prods[it.prod];
            printf("  %c->",p->lhs);
            for(int j=0;j<=p->len;j++){
                if(j==it.dot) printf(".");
                if(j<p->len) printf("%c",p->rhs[j]);
            }
            printf("\n");
        }
    }
}

void printParsingTable(){
    printf("\nPARSING TABLE:\n\n");

    printf("%-6s","State");
    for(int c=0;c<num_cols;c++)
        if(isTerminal(col_sym[c]) || col_sym[c]=='$')
            printf("%-10c",col_sym[c]);
    for(int c=0;c<num_cols;c++)
        if(isNonTerminal(col_sym[c]))
            printf("%-10c",col_sym[c]);
    printf("\n");

    for(int s=0;s<num_states;s++){
        printf("%-6d",s);

        for(int c=0;c<num_cols;c++){
            if(!(isTerminal(col_sym[c]) || col_sym[c]=='$'))
                continue;

            if(action_table[s][c].type=='s')
                printf("s%-9d",action_table[s][c].val);
            else if(action_table[s][c].type=='r')
                printf("r%-9d",action_table[s][c].val);
            else if(action_table[s][c].type=='a')
                printf("%-10s","acc");
            else
                printf("%-10s","-");
        }

        for(int c=0;c<num_cols;c++){
            if(!isNonTerminal(col_sym[c]))
                continue;

            if(goto_table[s][c]==-1)
                printf("%-10s","-");
            else
                printf("%-10d",goto_table[s][c]);
        }

        printf("\n");
    }
}

void parse(char *input){
    int stack[STACK];
    int top=0;
    char inp[100];
    strcpy(inp,input);
    if(inp[strlen(inp)-1]!='$')
        strcat(inp,"$");
    stack[0]=0;
    int ip=0;

    printf("\n%-24s %-20s %s\n","Stack","Input","Action");

    while(1){
        char look=inp[ip];
        int col=-1;
        for(int c=0;c<num_cols;c++)
            if(col_sym[c]==look){col=c;break;}

        char stackStr[256]="";
        for(int i=0;i<=top;i++){
            char tmp[16];
            sprintf(tmp,"%d",stack[i]);
            strcat(stackStr,tmp);
            if(i<top) strcat(stackStr," ");
        }
        printf("%-24s %-20s ",stackStr,inp+ip);

        if(col==-1){
            printf("ERROR (symbol '%c' not in parsing table)\n",look);
            return;
        }
        Entry e=action_table[stack[top]][col];
        if(e.type=='s'){
            printf("Shift s%d\n",e.val);
            stack[++top]=e.val;
            ip++;
        }
        else if(e.type=='r'){
            int p=e.val;
            printf("Reduce %c->%s\n",prods[p].lhs,prods[p].rhs);
            top-=prods[p].len;
            char nt=prods[p].lhs;
            int gc=-1;
            for(int c=0;c<num_cols;c++)
                if(col_sym[c]==nt){gc=c;break;}
            if(gc==-1){
                printf("ERROR (goto column missing for %c)\n",nt);
                return;
            }
            int ns=goto_table[stack[top]][gc];
            if(ns==-1){
                printf("ERROR (goto undefined for state %d, symbol %c)\n",stack[top],nt);
                return;
            }
            stack[++top]=ns;
        }
        else if(e.type=='a'){
            printf("ACCEPT\n");
            return;
        }
        else{
            printf("ERROR\n");
            return;
        }
    }
}

int main(){
    printf("Enter number of productions: ");
    scanf("%d",&num_prod);
    for(int i=0;i<num_prod;i++){
        char temp[50];
        printf("prod %d: ",i);
        scanf("%s",temp);
        prods[i].lhs=temp[0];
        strcpy(prods[i].rhs,temp+3);
        prods[i].len=strlen(prods[i].rhs);
    }
    computeFollow();
    buildStates();
    buildColumns();
    buildTable();
    printItemSets();
    printParsingTable();
    char input[100];
    printf("\nEnter input string: ");
    scanf("%s",input);
    parse(input);
    return 0;
}