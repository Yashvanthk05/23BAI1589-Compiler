%{
#include<stdio.h>
#include<string.h>
#include<ctype.h>

#define MAX 20

char lhs[MAX];
char rhs[MAX][MAX];
int  pcnt=0;

char nonT[MAX];
int ntCount=0;
char Tset[MAX];
int tCount=0;

char FIRST[MAX][MAX];
char FOLLOW[MAX][MAX];

char curLHS=0;
char curRHS[MAX]="";

int indexNT(char c){
    for(int i=0;i<ntCount;i++)
        if(nonT[i]==c) return i;
    return -1;
}

int indexT(char c){
    for(int i=0;i<tCount;i++)
        if(Tset[i]==c) return i;
    return -1;
}

void addNT(char c){
    if(indexNT(c)==-1) nonT[ntCount++]=c;
}

void addT(char c){
    if(indexT(c)==-1) Tset[tCount++]=c;
}

void addToSet(char *set,char c){
    if(!strchr(set, c)){
        int l=strlen(set);
        set[l]=c;set[l+1]='\0';
    }
}

int inSet(char *set,char c){
    return strchr(set,c)!=NULL;
}

void saveProd(){
    if(curLHS==0 || curRHS[0]=='\0') return;
    lhs[pcnt]=curLHS;
    strcpy(rhs[pcnt],curRHS);
    pcnt++;
    curRHS[0]='\0';
}

void computeFirst(){
    for(int i=0;i<ntCount;i++) FIRST[i][0]='\0';
    int changed=1;
    while(changed){
        changed=0;
        for(int p=0;p<pcnt;p++){
            int ai=indexNT(lhs[p]);
            char *r=rhs[p];
            int pre=strlen(FIRST[ai]);

            if(r[0]=='#'){
                addToSet(FIRST[ai],'#');
            } else {
                int allEps=1;
                for(int j=0;r[j] && allEps;j++){
                    allEps=0;
                    if(!isupper(r[j])){
                        addToSet(FIRST[ai],r[j]);
                    } else {
                        int bi=indexNT(r[j]);
                        if(bi==-1) continue;
                        for(int k=0;FIRST[bi][k];k++)
                            if(FIRST[bi][k]!='#')
                                addToSet(FIRST[ai],FIRST[bi][k]);
                        if(inSet(FIRST[bi],'#')) allEps=1;
                    }
                }
                if(allEps) addToSet(FIRST[ai],'#');
            }
            if((int)strlen(FIRST[ai])!=pre) changed=1;
        }
    }
}

void computeFollow() {
    for (int i=0;i<ntCount;i++) FOLLOW[i][0]='\0';
    addToSet(FOLLOW[0],'$');
    addT('$');
    int changed=1;
    while(changed){
        changed=0;
        for(int p=0;p<pcnt;p++) {
            char *r=rhs[p];
            int ai=indexNT(lhs[p]);
            for(int j=0;r[j];j++) {
                if(!isupper(r[j])) continue;
                int bi=indexNT(r[j]);
                if(bi==-1) continue;
                int pre=strlen(FOLLOW[bi]);
                int allEps = 1;
                for(int k=j+1;r[k]&&allEps;k++) {
                    if(!isupper(r[k])) {
                        if(r[k]=='#') {
                            allEps=1;
                        } else {
                            addToSet(FOLLOW[bi],r[k]);
                            allEps=0;
                        }
                    }
                    else{
                        int ci=indexNT(r[k]);
                        if(ci==-1) continue;
                        for(int m=0;FIRST[ci][m];m++)
                            if(FIRST[ci][m]!='#')
                                addToSet(FOLLOW[bi],FIRST[ci][m]);
                        if(inSet(FIRST[ci],'#')) allEps=1;
                        else allEps=0;
                    }
                }
                if(allEps){
                    for(int k=0;FOLLOW[ai][k];k++){
                        addToSet(FOLLOW[bi],FOLLOW[ai][k]);
                    }
                }
                if((int)strlen(FOLLOW[bi])!=pre) changed=1;
            }
        }
    }
}

int  yylex();
void yyerror(const char *s){
    printf("Syntax error: %s\n",s);
}

void printSym(char c){
    if(c=='#') printf("e");
    else if(c=='@') printf("id");
    else printf("%c",c);
}

void printRHS(const char *s){
    for(int i=0;s[i];i++) printSym(s[i]);
}
%}

%union { char ch; }
%token <ch> NT T
%token ARROW OR NL

%%
input: input line | ;

line: NT { curLHS = $1; curRHS[0] = '\0'; addNT($1); }
    ARROW rhs NL { saveProd(); }
    ;

rhs: rhs OR { saveProd(); } symbols
    | symbols
    ;

symbols : symbols symbol | symbol ;

symbol: NT { 
            int l=strlen(curRHS);
            curRHS[l]=$1;
            curRHS[l+1]='\0';
            addNT($1);
           }
    | T  {
            int l=strlen(curRHS);
            curRHS[l]=$1;
            curRHS[l+1]='\0';
         }
    ;
%%

int main(){
    printf("Enter productions:\n");
    yyparse();
    saveProd();
    computeFirst();
    computeFollow();
    printf("\nProductions:\n");
    for (int i=0;i<pcnt;i++){
        printf("%c -> ",lhs[i]);
        printRHS(rhs[i]);
        printf("\n");
    }

    printf("\nFIRST set:\n");
    for (int i=0;i<ntCount;i++) {
        printf("FIRST(%c) = { ",nonT[i]);
        for (int j=0;FIRST[i][j];j++){
            printSym(FIRST[i][j]);
            printf(" ");
        }
        printf("}\n");
    }
    printf("\nFOLLOW set:\n");
    for (int i=0;i<ntCount;i++) {
        printf("FOLLOW(%c) = { ",nonT[i]);
        for (int j=0;FOLLOW[i][j];j++){
            printSym(FOLLOW[i][j]);
            printf(" ");
        }
        printf("}\n");
    }
    return 0;
}
