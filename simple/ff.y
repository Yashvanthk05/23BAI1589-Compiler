%{
#include <stdio.h>
#include <string.h>
#include <ctype.h>

#define MAXP 20
#define MAXS 20

typedef struct {
    char lhs;
    char rhs[MAXS];
} Prod;

Prod prods[MAXP];
int  pc  = 0;
char NTs[MAXS];
int  ntc = 0;
char curLHS;
char curRHS[MAXS];

void yyerror(char *s){ fprintf(stderr, "Error: %s\n", s); }
int  yylex();

/* ── helpers ── */
void addToSet(char *s, char c){
    if(!strchr(s, c)){
        int n = strlen(s);
        s[n] = c; s[n+1] = '\0';
    }
}

void saveProd(){
    prods[pc].lhs = curLHS;
    strcpy(prods[pc].rhs, curRHS);
    pc++;
    curRHS[0] = '\0';
}

/* ── FIRST ── */
void calcFirst(char c, char *res, char *vis){
    if(!isupper(c)){          // terminal
        addToSet(res, c);
        return;
    }
    if(strchr(vis, c)) return; // already visited
    addToSet(vis, c);

    for(int i = 0; i < pc; i++){
        if(prods[i].lhs != c) continue;
        char *r = prods[i].rhs;

        if(r[0] == '#'){       // epsilon production
            addToSet(res, '#');
            continue;
        }

        for(int j = 0; r[j]; j++){
            char tmp[MAXS] = "", v2[MAXS] = "";
            strcpy(v2, vis);
            calcFirst(r[j], tmp, v2);

            for(int k = 0; tmp[k]; k++)
                if(tmp[k] != '#') addToSet(res, tmp[k]);

            if(!strchr(tmp, '#')) break;      // no epsilon, stop
            if(!r[j+1]) addToSet(res, '#');   // all symbols had epsilon
        }
    }
}

/* ── FOLLOW ── */
void calcFollow(char c, char *res, char *vis){
    if(strchr(vis, c)) return;
    addToSet(vis, c);

    if(c == NTs[0]) addToSet(res, '$');  // start symbol

    for(int i = 0; i < pc; i++){
        char *r = prods[i].rhs;
        char  l = prods[i].lhs;

        for(int j = 0; r[j]; j++){
            if(r[j] != c) continue;

            if(r[j+1]){
                // something after c
                char tmp[MAXS] = "", v2[MAXS] = "";
                calcFirst(r[j+1], tmp, v2);

                for(int k = 0; tmp[k]; k++)
                    if(tmp[k] != '#') addToSet(res, tmp[k]);

                if(strchr(tmp, '#') && l != c){
                    char v3[MAXS] = "";
                    strcpy(v3, vis);
                    calcFollow(l, res, v3);
                }
            } else {
                // c at end of rhs
                if(l != c){
                    char v3[MAXS] = "";
                    strcpy(v3, vis);
                    calcFollow(l, res, v3);
                }
            }
        }
    }
}

/* ── print ── */
void printAll(){
    printf("\n%-8s %-20s %s\n", "Symbol", "FIRST", "FOLLOW");
    printf("------------------------------------------\n");
    for(int i = 0; i < ntc; i++){
        char f1[MAXS]="", v1[MAXS]="";
        char f2[MAXS]="", v2[MAXS]="";
        calcFirst (NTs[i], f1, v1);
        calcFollow(NTs[i], f2, v2);
        printf("  %-8c {%-15s} {%s}\n", NTs[i], f1, f2);
    }
}
%}

%union { char ch; }
%token <ch> NT TER
%token EQ PIPE NEWLINE

%%
input : input line | line ;

line  : NT {
            curLHS = $1;
            curRHS[0] = '\0';
            if(!strchr(NTs, $1)) NTs[ntc++] = $1;
        }
        EQ rhs NEWLINE
      ;

rhs   : rhs PIPE alt { saveProd(); }
      | alt           { saveProd(); }
      ;

alt   : alt NT  { int n=strlen(curRHS); curRHS[n]=$2; curRHS[n+1]='\0'; }
      | alt TER { int n=strlen(curRHS); curRHS[n]=$2; curRHS[n+1]='\0'; }
      | NT      { curRHS[0]=$1; curRHS[1]='\0'; }
      | TER     { curRHS[0]=$1; curRHS[1]='\0'; }
      ;
%%

int main(){
    printf("Enter grammar (one rule per line, press Ctrl+D when done):\n");
    printf("Example:  E=E+T|T\n\n");
    yyparse();
    printAll();
    return 0;
}