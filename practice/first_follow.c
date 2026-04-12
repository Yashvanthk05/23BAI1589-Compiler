#include <stdio.h>
#include <string.h>
#include <ctype.h>

int n;
char prod[10][20];

// Check if c is already in set
int inSet(char *set, char c){
    return strchr(set, c) != NULL;
}

// Add c to set if not present
void addToSet(char *set, char c){
    if(!inSet(set, c)){
        int len = strlen(set);
        set[len] = c;
        set[len+1] = '\0';
    }
}

// Check if symbol is NonTerminal (uppercase)
int isNT(char c){
    return isupper(c);
}

void findFirst(char c, char *result, char *visited){
    // Avoid infinite recursion
    if(inSet(visited, c)) return;
    addToSet(visited, c);

    // Terminal or epsilon → add directly
    if(!isNT(c)){
        addToSet(result, c);
        return;
    }

    for(int i = 0; i < n; i++){
        if(prod[i][0] != c) continue;

        char *rhs = prod[i] + 2;  // skip "X="

        // Epsilon production
        if(rhs[0] == '#'){
            addToSet(result, '#');
            continue;
        }

        // Go through RHS symbols
        for(int j = 0; rhs[j] != '\0'; j++){
            char temp[20] = "";
            char vis2[20] = "";
            strcpy(vis2, visited);

            findFirst(rhs[j], temp, vis2);

            // Add everything except epsilon
            for(int k = 0; temp[k]; k++)
                if(temp[k] != '#')
                    addToSet(result, temp[k]);

            // If epsilon not in FIRST(rhs[j]), stop
            if(!inSet(temp, '#')) break;

            // If last symbol, add epsilon
            if(rhs[j+1] == '\0')
                addToSet(result, '#');
        }
    }
}

void findFollow(char c, char *result, char *visited){
    // Avoid infinite recursion
    if(inSet(visited, c)) return;
    addToSet(visited, c);

    // Start symbol always has $
    if(c == prod[0][0])
        addToSet(result, '$');

    for(int i = 0; i < n; i++){
        char *rhs = prod[i] + 2;
        char  lhs = prod[i][0];

        for(int j = 0; rhs[j] != '\0'; j++){
            if(rhs[j] != c) continue;

            if(rhs[j+1] != '\0'){
                // Something follows c
                char temp[20] = "";
                char vis2[20] = "";
                findFirst(rhs[j+1], temp, vis2);

                // Add FIRST(next) - epsilon to FOLLOW
                for(int k = 0; temp[k]; k++)
                    if(temp[k] != '#')
                        addToSet(result, temp[k]);

                // If epsilon in FIRST(next), add FOLLOW(lhs)
                if(inSet(temp, '#') && lhs != c){
                    char vis3[20] = "";
                    strcpy(vis3, visited);
                    findFollow(lhs, result, vis3);
                }
            } else {
                // c at end of RHS → add FOLLOW(lhs)
                if(lhs != c){
                    char vis3[20] = "";
                    strcpy(vis3, visited);
                    findFollow(lhs, result, vis3);
                }
            }
        }
    }
}

int main(){
    printf("Enter number of productions: ");
    scanf("%d", &n);
    printf("Enter productions (use = instead of ->, e.g. E=E+T, use # for epsilon):\n");
    for(int i = 0; i < n; i++)
        scanf("%s", prod[i]);

    // Collect unique non-terminals
    char nts[10] = "";
    for(int i = 0; i < n; i++)
        addToSet(nts, prod[i][0]);

    printf("\nFIRST sets:\n");
    for(int i = 0; nts[i]; i++){
        char result[20] = "";
        char visited[20] = "";
        findFirst(nts[i], result, visited);
        printf("FIRST(%c) = { ", nts[i]);
        for(int j = 0; result[j]; j++) printf("%c ", result[j]);
        printf("}\n");
    }

    printf("\nFOLLOW sets:\n");
    for(int i = 0; nts[i]; i++){
        char result[20] = "";
        char visited[20] = "";
        findFollow(nts[i], result, visited);
        printf("FOLLOW(%c) = { ", nts[i]);
        for(int j = 0; result[j]; j++) printf("%c ", result[j]);
        printf("}\n");
    }

    return 0;
}