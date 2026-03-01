%{
#include <stdio.h>
#include <string.h>
#include <ctype.h>

#define MAX 50

int yylex();
void yyerror(char *s);

typedef struct {
    char lhs;
    char rhs[20];
} Production;

Production prods[MAX];
int prod_count = 0;

char first[26][MAX];
char follow[26][MAX];

int contains(char *set, char c) {
    for(int i=0; set[i]; i++)
        if(set[i]==c) return 1;
    return 0;
}

void addToSet(char *set, char c) {
    if(!contains(set,c)) {
        int l=strlen(set);
        set[l]=c;
        set[l+1]='\0';
    }
}
%}

%union {
    char sym;
}

%token <sym> NONTERM TERM EPS
%token ARROW OR NL

%%

input:
    lines
;

lines:
    lines line
    | line
;

line:
    NONTERM ARROW rhs NL
;

rhs:
    symbols
    | rhs OR symbols
;

symbols:
    symbols symbol
    | symbol
;

symbol:
    NONTERM {
        prods[prod_count].lhs = $<sym>-2;
        strncat(prods[prod_count].rhs, &($1), 1);
    }
    | TERM {
        strncat(prods[prod_count].rhs, &($1), 1);
    }
    | EPS {
        prods[prod_count].rhs[0] = '#';
        prods[prod_count].rhs[1] = '\0';
    }
;

%%

void yyerror(char *s) {
    printf("Invalid Grammar Input\n");
}

int main() {
    printf("Enter Grammar (Ctrl+D to stop):\n");
    yyparse();

    printf("\nProductions:\n");
    for(int i=0;i<prod_count;i++)
        printf("%c -> %s\n", prods[i].lhs, prods[i].rhs);

    printf("\n(Implement FIRST/FOLLOW + Conflict Check Here)\n");

    return 0;
}