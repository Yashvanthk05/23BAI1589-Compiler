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
    char types[4][10]={"int","float","char","double"};
    for(int i=0;i<4;i++){
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
        printf("%s identifier with scope %s is already declared\n",name,scopename);
        return;
    }
    strcpy(table[identifiers].name,name);
    strcpy(table[identifiers].type,datatype);
    strcpy(table[identifiers].scope,scopename);
    strcpy(table[identifiers].value,value);
    table[identifiers].address=address;
    address+=4;
    identifiers++;
}

int main(){
    FILE *fp;
    char character;
    char buffer[50],type[10],value[10];
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

        if(isalnum(character) || character=='_' || (character=='.' && i>0 && !strchr(buffer,character))){
            buffer[i++]=character;
        }else{
            buffer[i]='\0';
            i=0;
            if(dataType(buffer)){
                strcpy(type,buffer);
                nextidentifier=1;
            }else if(nextidentifier){
                strcpy(value,"-");
                insert(buffer,type,value);
                nextidentifier=0;
                nextval=1;
            }else if(nextval){
                strcpy(table[identifiers-1].value,buffer);
                nextval=0;
            }
        }
    }
    fclose(fp);
    printf("Symbol Table of %s program\n",filename);
    printf("Name\tType\tScope\tValue\tAddress\n");
    for(int i=0;i<identifiers;i++){
        printf("%s\t%s\t%s\t\%s\t\%d\n",table[i].name,table[i].type,table[i].scope,table[i].value,table[i].address);
    }
    return 0;
}