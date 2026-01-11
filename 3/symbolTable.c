#include<stdio.h>
#include<ctype.h>
#include<string.h>

struct symbolTable{
    char name[50];
    char type[10];
    char scope[10];
    char value[20];
    int address;
};

struct symbolTable table[100];

int identifiers=0;
int address=1000;
int scope=0;

int dataType(char word[]){
    char types[5][10]={"int","float","char","double","string"};
    for(int i=0;i<5;i++){
        if(strcmp(word,types[i])==0) return 1;
    }
    return 0;
}

int duplicateChecking(char name[],char scopename[]){
    for(int i=0;i<identifiers;i++){
        if(strcmp(table[i].name,name)==0 && strcmp(table[i].scope,scopename)==0) return 1;
    }
    return 0;
}

void insert(char name[],char datatype[],char value[]){
    char scopename[10];
    if(scope==0){
        strcpy(scopename,"global");
    }
    else{
        strcpy(scopename,"local");
    }
    if(duplicateChecking(name,scopename)){
        printf("[Error]: %s identifier with scope %s is already declared\n",name,scopename);
        return;
    }
    strcpy(table[identifiers].name,name);
    strcpy(table[identifiers].type,datatype);
    strcpy(table[identifiers].scope,scopename);
    if(strcmp(value,"")==0){
        strcpy(table[identifiers].value,"-");
    }else{
        strcpy(table[identifiers].value,value);
    }
    table[identifiers].address=address;
    if(strcmp(datatype,"int")==0 || strcmp(datatype,"float")==0){
        address+=4;
    }else if(strcmp(datatype,"double")==0){
        address+=8;
    }else if(strcmp(datatype,"string")==0){
        address+=strlen(value)-2;
    }else{
        address++;
    }
    identifiers++;
}

int main(){
    FILE *fp;
    char character;
    char buffer[50],type[10],identifier[10];
    int i=0;
    int nextidentifier=0,nextval=0;
    
    char filename[50];
    printf("Enter the file name: ");
    scanf("%s",filename);

    fp=fopen(filename,"r");
    if(fp==NULL){
        printf("File cannot be opened");
        return 1;
    }

    while((character=fgetc(fp))!=EOF){
        if(character=='{') scope=1;
        if(character=='}') scope=0;

        if(isalnum(character) || character=='_' || (character=='.' && i>0 && !strchr(buffer,character)) || character=='"' || character=='\''){
            buffer[i++]=character;
        }else{
            buffer[i]='\0';
            i=0;
            if(dataType(buffer)){
                strcpy(type,buffer);
                nextidentifier=1;
            }else if(nextidentifier){
                strcpy(identifier,buffer);
                nextidentifier=0;
                nextval=1;
            }else if(nextval){
                insert(identifier,type,buffer);
                nextval=0;
            }
        }
    }

    fclose(fp);

    printf("\nSymbol Table of %s program\n",filename);
    printf("Name\tType\tScope\tValue\tAddress\n");

    for(int i=0;i<identifiers;i++){
        printf("%s\t%s\t%s\t\%s\t%d\n",table[i].name,table[i].type,table[i].scope,table[i].value,table[i].address);
    }
    return 0;
}