%{
#include <stdio.h>
#include <string.h>
#include <ctype.h>

#define MAX 20

char lhs[MAX], rhs[MAX][MAX];
int  pcnt = 0;

char nonT[MAX]; int ntCount = 0;
char Tset[MAX]; int tCount  = 0;

char FIRST[MAX][MAX];
char FOLLOW[MAX][MAX];

char curLHS = 0, curRHS[MAX] = "";

/* ── helpers ── */
int indexNT(char c){ for(int i=0;i<ntCount;i++) if(nonT[i]==c) return i; return -1; }
int indexT (char c){ for(int i=0;i<tCount; i++) if(Tset[i] ==c) return i; return -1; }
void addNT(char c){ if(indexNT(c)==-1) nonT[ntCount++]=c; }
void addT (char c){ if(indexT(c) ==-1) Tset[tCount++] =c; }
void addToSet(char *s, char c){ if(!strchr(s,c)){int l=strlen(s);s[l]=c;s[l+1]='\0';} }

void saveProd(){
    if(!curLHS || !curRHS[0]) return;
    lhs[pcnt]=curLHS; strcpy(rhs[pcnt++],curRHS); curRHS[0]='\0';
}

/* ── FIRST (needed internally for FOLLOW) ── */
void computeFirst(){
    for(int i=0;i<ntCount;i++) FIRST[i][0]='\0';
    int changed=1;
    while(changed){ changed=0;
        for(int p=0;p<pcnt;p++){
            int ai=indexNT(lhs[p]); char *r=rhs[p]; int pre=strlen(FIRST[ai]);
            if(r[0]=='#'){ addToSet(FIRST[ai],'#'); }
            else{
                int ae=1;
                for(int j=0;r[j]&&ae;j++){ ae=0;
                    if(!isupper(r[j])){ addToSet(FIRST[ai],r[j]); }
                    else{ int bi=indexNT(r[j]); if(bi==-1) continue;
                        for(int k=0;FIRST[bi][k];k++)
                            if(FIRST[bi][k]!='#') addToSet(FIRST[ai],FIRST[bi][k]);
                        if(strchr(FIRST[bi],'#')) ae=1; }
                }
                if(ae) addToSet(FIRST[ai],'#');
            }
            if((int)strlen(FIRST[ai])!=pre) changed=1;
        }
    }
}

/* ── FOLLOW ── */
void computeFollow(){
    for(int i=0;i<ntCount;i++) FOLLOW[i][0]='\0';
    addToSet(FOLLOW[0],'$');          /* Rule 1: $ in FOLLOW(start) */
    int changed=1;
    while(changed){ changed=0;
        for(int p=0;p<pcnt;p++){
            int ai=indexNT(lhs[p]); char *r=rhs[p];
            for(int j=0;r[j];j++){
                if(!isupper(r[j])) continue;
                int bi=indexNT(r[j]); if(bi==-1) continue;
                int pre=strlen(FOLLOW[bi]);
                int ae=1;             /* assume trailer can vanish */
                for(int k=j+1;r[k]&&ae;k++){ ae=0;
                    if(!isupper(r[k])){           /* Rule 2a: terminal follows */
                        if(r[k]!='#') addToSet(FOLLOW[bi],r[k]);
                        else ae=1;                /* '#' literal — keep going */
                    } else {                      /* Rule 2b: NT follows */
                        int ci=indexNT(r[k]); if(ci==-1) continue;
                        for(int m=0;FIRST[ci][m];m++)
                            if(FIRST[ci][m]!='#') addToSet(FOLLOW[bi],FIRST[ci][m]);
                        if(strchr(FIRST[ci],'#')) ae=1;
                    }
                }
                if(ae)                /* Rule 3: trailer →* ε, add FOLLOW(lhs) */
                    for(int k=0;FOLLOW[ai][k];k++)
                        addToSet(FOLLOW[bi],FOLLOW[ai][k]);
                if((int)strlen(FOLLOW[bi])!=pre) changed=1;
            }
        }
    }
}

int  yylex();
void yyerror(const char *s){ printf("Error: %s\n",s); }
%}

%union { char ch; }
%token <ch> NT T
%token ARROW OR NL

%%
input : input line | ;

line  : NT          { curLHS=$1; curRHS[0]='\0'; addNT($1); }
        ARROW rhs NL { saveProd(); }
      ;

rhs   : rhs OR { saveProd(); } symbols
      | symbols
      ;

symbols : symbols symbol | symbol ;

symbol : NT { int l=strlen(curRHS); curRHS[l]=$1; curRHS[l+1]='\0'; addNT($1); }
       | T  { int l=strlen(curRHS); curRHS[l]=$1; curRHS[l+1]='\0'; if($1!='#') addT($1); }
       ;
%%

int main(){
    printf("Enter productions (# = epsilon, end with Ctrl+D):\n");
    yyparse();
    saveProd();
    computeFirst();
    computeFollow();

    printf("\nProductions:\n");
    for(int i=0;i<pcnt;i++) printf("  P%d: %c -> %s\n",i+1,lhs[i],rhs[i]);

    printf("\nFOLLOW sets:\n");
    for(int i=0;i<ntCount;i++){
        printf("  FOLLOW(%c) = { ",nonT[i]);
        for(int j=0;FOLLOW[i][j];j++) printf("%c ",FOLLOW[i][j]);
        printf("}\n");
    }
    return 0;
}
