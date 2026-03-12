/*
 * Experiment No. 9: LALR Parser
 * Grammar:
 *   S --> AA
 *   A --> aA | b
 *
 * Augmented Grammar:
 *   S' --> S      (production 0)
 *   S  --> AA     (production 1)
 *   A  --> aA     (production 2)
 *   A  --> b      (production 3)
 *
 * LALR(1) Parsing Table (hand-constructed):
 *
 * ACTION table (rows = states, cols = a, b, $):
 *   State | a    | b    | $
 *   ------+------+------+------
 *     0   | S3   | S4   | -
 *     1   | -    | -    | ACC
 *     2   | S3   | S4   | -
 *     3   | S3   | S4   | -
 *     4   | R3   | R3   | R3
 *     5   | -    | -    | R1
 *     6   | R2   | R2   | R2
 *
 * GOTO table (rows = states, cols = S, A):
 *   State | S | A
 *   ------+---+---
 *     0   | 1 | 2
 *     2   | - | 5
 *     3   | - | 6
 *
 * Productions:
 *   P1: S  --> AA   (len=2, lhs=S)
 *   P2: A  --> aA   (len=2, lhs=A)
 *   P3: A  --> b    (len=1, lhs=A)
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_STACK 100
#define MAX_INPUT 100

#define SYM_a   0
#define SYM_b   1
#define SYM_EOF 2
#define SYM_S   3
#define SYM_A   4

#define ERR    0
#define SHIFT  1
#define REDUCE 2
#define ACCEPT 3

typedef struct { int type; int value; } Action;

Action action[7][3] = {
/*         a              b              $         */
/* 0 */ {{SHIFT,3},  {SHIFT,4},  {ERR,0}   },
/* 1 */ {{ERR,0},    {ERR,0},    {ACCEPT,0}},
/* 2 */ {{SHIFT,3},  {SHIFT,4},  {ERR,0}   },
/* 3 */ {{SHIFT,3},  {SHIFT,4},  {ERR,0}   },
/* 4 */ {{REDUCE,3}, {REDUCE,3}, {REDUCE,3}},
/* 5 */ {{ERR,0},    {ERR,0},    {REDUCE,1}},
/* 6 */ {{REDUCE,2}, {REDUCE,2}, {REDUCE,2}}
};

int goto_tbl[7][2] = {
{1,2 },
{-1,-1 },
{-1, 5 },
{-1, 6 },
{-1,-1 },
{-1,-1 },
{-1,-1 }
};

typedef struct { int lhs; int len; const char *name; } Prod;

Prod prods[] = {
    {0,     0, ""},
    {SYM_S, 2, "S --> AA"},
    {SYM_A, 2, "A --> aA"},
    {SYM_A, 1, "A --> b" }
};

/* ─── helpers ─── */

int sym_idx(char c) {
    if (c == 'a') return SYM_a;
    if (c == 'b') return SYM_b;
    if (c == '$') return SYM_EOF;
    return -1;
}

const char *sym_str(int s) {
    switch(s) {
        case SYM_a:   return "a";
        case SYM_b:   return "b";
        case SYM_EOF: return "$";
        case SYM_S:   return "S";
        case SYM_A:   return "A";
    }
    return "?";
}

void parse(const char *raw){
    char inp[MAX_INPUT + 2];
    strncpy(inp, raw, MAX_INPUT);
    inp[MAX_INPUT] = '\0';
    size_t n = strlen(inp);
    if (n == 0 || inp[n-1] != '$') { inp[n] = '$'; inp[n+1] = '\0'; }

    int st[MAX_STACK], sy[MAX_STACK], top = 0;
    st[0] = 0;
    int ip = 0;

    printf("\n%-10s %-10s %-10s %-10s\n","Stack (states)", "Symbols", "Input", "Action");

    while (1) {
        char ss[200]="", syms[200]="";
        for (int i=0; i<=top; i++) { char t[8]; sprintf(t,"%d ",st[i]); strcat(ss,t); }
        for (int i=1; i<=top; i++) { strcat(syms, sym_str(sy[i])); strcat(syms," "); }
        if (!syms[0]) strcpy(syms,"-");

        int cur = st[top];
        int t   = sym_idx(inp[ip]);

        if (t == -1) {
            printf("ERROR: unrecognised symbol '%c'\n", inp[ip]);
            return;
        }

        Action a = action[cur][t];
        printf("%-22s %-12s %-16s ", ss, syms, inp+ip);

        if (a.type == SHIFT) {
            printf("Shift  --> state %d\n", a.value);
            top++;
            st[top] = a.value;
            sy[top] = t;
            ip++;

        } else if (a.type == REDUCE) {
            Prod *p = &prods[a.value];
            printf("Reduce by  %s\n", p->name);
            top -= p->len;
            int prev = st[top];
            int nt = p->lhs - SYM_S;
            int ns = goto_tbl[prev][nt];
            if (ns == -1) {
                printf("ERROR: GOTO missing for state %d on %s\n",
                       prev, sym_str(p->lhs));
                return;
            }
            top++;
            st[top] = ns;
            sy[top] = p->lhs;

        } else if (a.type == ACCEPT) {
            printf("ACCEPT — string is valid!\n");
            return;

        } else {
            printf("ERROR — invalid string!\n");
            return;
        }
    }
}

int main(void) {
    char input[MAX_INPUT];
    printf("\nEnter input string (e.g. aabb, bb, aab, ab): ");
    if (!fgets(input, sizeof(input), stdin)) return 1;
    input[strcspn(input, "\n")] = '\0';

    if (!input[0]) { printf("Empty input.\n"); return 1; }

    parse(input);
    return 0;
}