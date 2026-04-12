%{
#include<stdio.h>
#include<string.h>
#include<ctype.h>
#include<stdlib.h>

#define MAXP 20
#define MAXS 20

typedef struct Prod{
    char lhs;
    char rhs[MAXS];
}Prod;

char curLHS,curRHS[MAXS];
char NTs[MAXS];
Prod prods[MAXP];
int p=0;
int nt=0;

void addset(char *s, char c){
    if(!strchr(s,c)){
        int n = strlen(s);
        s[n] = c;
        s[n+1] = '\0';
    }
}

void saveprod(){
    prods[p].lhs=curLHS;
    strcpy(prods[p].rhs,curRHS);
    curRHS[0]='\0';
    p++;
}

void computeFirst(char c, char *res, char *visited){
    if(!isupper(c)){
        addset(res,c);
        return;
    }
    if(strchr(visited,c)) return;
    addset(visited,c);

    for(int i=0;i<p;i++){
        if(prods[i].lhs!=c) continue;
        char *rhs = prods[i].rhs;
        if(rhs[0]=='#'){
            addset(res, '#');
            continue;
        }
        for(int j=0;rhs[j];j++){
            char temp[MAXS]="",visited2[MAXS]="";
            strcpy(visited2,visited);
            computeFirst(rhs[j],temp,visited2);
            for(int k=0;temp[k];k++){
                if(temp[k]!='#') addset(res,temp[k]);
            }
            if(!strchr(temp,'#')) break;
            if(!rhs[j+1]) addset(res, '#');
        }
    }
}

void printfirst(){
    printf("\nFirst:\n");
    for(int i=0;i<nt;i++){
        char temp[MAXS]="",visited[MAXS]="";
        computeFirst(NTs[i],temp,visited);
        printf("First of %c: %s\n",NTs[i],temp);
    }
}

void computeFollow(char c, char *res, char *visited){
    if(strchr(visited,c)) return;
    addset(visited,c);
    if(NTs[0]==c) addset(res, '$');
    for(int i=0;i<p;i++){
        char l = prods[i].lhs;
        char *r = prods[i].rhs;
        for(int j=0;r[j];j++){
            if(r[j]!=c) continue;

            if(r[j+1]){
                int allEps = 1;
                for(int k=j+1;r[k];k++){
                    char temp[MAXS]="", visited2[MAXS]="";
                    strcpy(visited2,visited);
                    computeFirst(r[k],temp,visited2);
                    for(int m=0;temp[m];m++){
                        if(temp[m]!='#') addset(res,temp[m]);
                    }
                    if(!strchr(temp,'#')){
                        allEps=0;
                        break;
                    }
                }
                if(allEps && l!=c){
                    char visited3[MAXS]="";
                    strcpy(visited3,visited);
                    computeFollow(l,res,visited3);
                }
            }else if(l!=c){
                char visited3[MAXS]="";
                strcpy(visited3,visited);
                computeFollow(l,res,visited3);
            }
        }
    }
}

void printFollow(){
    printf("\nFollow:\n");
    for(int i=0;i<nt;i++){
        char temp[MAXS]="",visited[MAXS]="";
        computeFollow(NTs[i],temp,visited);
        printf("Follow of %c: %s\n",NTs[i],temp);
    }
}

void firststring(char *r, char *res){
    for(int i=0;r[i];i++){
        char temp[MAXS]="",vis[MAXS]="";
        computeFirst(r[i],temp,vis);
        for(int j=0;temp[j];j++) if(temp[j]!='#') addset(res,temp[j]);
        if(!strchr(temp,'#')) return;
        if(!r[i+1]) addset(res,'#');
    }
}

void checkll1(){
    for(int i=0;i<p;i++){
        char first1[MAXS]="";
        firststring(prods[i].rhs,first1);
        for(int j=i+1;j<p;j++){
            if(prods[i].lhs!=prods[j].lhs) continue;
            char first2[MAXS]="";
            firststring(prods[j].rhs,first2);
            for(int k=0;first2[k];k++){
                if(first2[k]!='#' && strchr(first1,first2[k])){
                    printf("Not LL1: conflict detected for %c\n",prods[i].lhs);
                    return;
                }
            }
            if(strchr(first1,'#')){
                char follow1[MAXS]="",v1[MAXS]="";
                computeFollow(prods[i].lhs,follow1,v1);
                for(int k=0;follow1[k];k++){
                    if(strchr(first2,follow1[k])){
                        printf("Conflict detected\n");
                        return;
                    }
                }
            }
            if(strchr(first2,'#')){
                char follow2[MAXS]="",v2[MAXS]="";
                computeFollow(prods[j].lhs,follow2,v2);
                for(int k=0;follow2[k];k++){
                    if(strchr(first1,follow2[k])){
                        printf("Conflict detected\n");
                        return;
                    }
                }
            }
        }
    }
    printf("Grammar is LL1\n");
}

int yylex();
void yyerror(char *s){
    fprintf(stderr, "%s\n",s);
}
%}

%union {
    char ch;
}

%token PIPE EQ NEWLINE END
%token <ch> NT T

%%
input:  input line
    |  line
    ;
line:   NT {
    curLHS = $1;
    curRHS[0]='\0';
    if(!strchr(NTs,$1)){
        addset(NTs,$1);
        nt++;
    } 
} EQ rhs NEWLINE
    | END { return 0; }
    ;
rhs:    rhs PIPE alt { saveprod(); }
    |   alt { saveprod(); }
    ;
alt:    alt NT {
    int n = strlen(curRHS);
    curRHS[n]=$2;
    curRHS[n+1]='\0';
}
    |   alt T {
    int n =strlen(curRHS);
    curRHS[n]=$2;
    curRHS[n+1]='\0';
}
    |   T { curRHS[0]=$1; curRHS[1]='\0'; }
    |   NT {curRHS[0]=$1; curRHS[1]='\0'; }
    ;
%%

int main(){
    printf("Enter the Productions:\n");
    yyparse();
    printfirst();
    printFollow();
    checkll1();
    return 0;
}