%{
#include<stdio.h>
#include<string.h>
#include<ctype.h>

#define MAX 20

char lhs[MAX];
char rhs[MAX][MAX];
int  pcnt=0;

char nonT[MAX];
int  ntCount=0;

char FIRST[MAX][MAX];

char curLHS=0;
char curRHS[MAX]="";

int idxNT(char c){
    for(int i=0;i<ntCount;i++){
        if(nonT[i]==c) return i;
    }
    return -1;
}

void addNT(char c) {
    if (idxNT(c)==-1) nonT[ntCount++]=c;
}

void addToSet(char *set,char c) {
    if(!strchr(set,c)){
        int l=strlen(set); 
        set[l]=c;
        set[l+1]='\0';
    }
}

void saveProd() {
    if (curLHS && curRHS[0]) {
        lhs[pcnt] = curLHS;
        strcpy(rhs[pcnt++], curRHS);
    }
    curRHS[0] = '\0';
}

void computeFirst(){
    for (int i=0;i<ntCount;i++) FIRST[i][0]='\0';
    int changed=1;
    while (changed){
        changed=0;
        for (int p=0;p<pcnt;p++) {
            int ai=idxNT(lhs[p]);
            char *r=rhs[p];
            int prev=strlen(FIRST[ai]);

            if (r[0]=='#'){
                addToSet(FIRST[ai],'#');
            }
            else{
                int allEps=1;
                for (int j=0;r[j] && allEps;j++) {
                    allEps = 0;
                    if (!isupper(r[j])){
                        addToSet(FIRST[ai],r[j]);
                    }
                    else{
                        int bi=idxNT(r[j]);
                        for (int k=0;FIRST[bi][k];k++)
                            if (FIRST[bi][k]!='#')
                                addToSet(FIRST[ai],FIRST[bi][k]);
                        if (strchr(FIRST[bi],'#')) allEps=1;
                    }
                }
                if(allEps) addToSet(FIRST[ai],'#');
            }
            if((int)strlen(FIRST[ai])!=prev) changed=1;
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
    return 0;
}
