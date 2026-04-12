#include<stdio.h>
#include<string.h>
#include<ctype.h>


int iskeyword(char* keyword) {
    char *keywords[] = {"int", "float", "double", "char", "if", "while", "else", "printf", "return"};
    int n = sizeof(keywords)/sizeof(keywords[0]);
    for (int i = 0;i < n;i++) {
        if(strcmp(keywords[i],keyword)==0) return 1;
    }
    return 0;
}

int isoperator(char ch) {
    char operators[] = "+-*/%<>=!&|";
    int n=sizeof(operators);
    for(int i=0;i<n;i++){
        if(operators[i]==ch) return 1;
    }
    return 0;
}

int isspecialsymbol(char ch){
    char symbols[] = "()[]{},;";
    int n = sizeof(symbols);
    for(int i=0;i<n;i++){
        if(symbols[i]==ch) return 1;
    }
    return 0;
}

int main(){
    char filename[50];
    scanf("%s",filename);
    FILE *fp;
    fp = fopen(filename, "r");
    if(!fp){
        printf("File not found");
        return 0;
    }
    char ch, buffer[50];
    int i = 0;

    while ((ch = fgetc(fp))!=EOF) {
        if (isalnum(ch) || ch == '_' || (ch == '.' && i > 0 && !strchr(buffer, ch))){
            buffer[i++] = ch;
        }else{
            if (i > 0){
                buffer[i] = '\0';
                i = 0;
                if(iskeyword(buffer)){
                    printf("Lexeme: %s [Keyword]\n",buffer);
                }else if(isdigit(buffer[0])){
                    printf("Lexeme: %s [Constant]\n",buffer);
                }else{
                    printf("Lexeme: %s [Identifier]\n",buffer);
                }
            }
            if (isoperator(ch)){
                printf("Lexeme: %c [Operator]\n",ch);
            }else if(ch=='#'){
                int j=0;
                buffer[j++]=ch;
                while ((ch=fgetc(fp))!='\n' && ch!=EOF){
                    buffer[j++]=ch;
                }
                printf("Lexeme: %s [Header File]\n",buffer);
            }else if(ch=='"'){
                int j=0;
                buffer[j++]=ch;
                while((ch=fgetc(fp))!='"' && ch!=EOF){
                    buffer[j++]=ch;
                }
                buffer[j++]='"';
                buffer[j]='\0';
                printf("Lexeme: %s [String constant]\n",buffer);
            }else if(isspecialsymbol(ch)){
                printf("Lexeme: %c [Special Symbol]\n",ch);
            }else if(ch=='\''){
                int j=0;
                while((ch=fgetc(fp))!='\'' && ch!=EOF){
                    buffer[j++]=ch;
                }
                buffer[j++]='\'';
                buffer[j]='\0';
            }
        }
    }
    fclose(fp);
    return 0;
}