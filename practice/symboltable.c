#include<stdio.h>
#include<string.h>
#include<ctype.h>

struct table{
    char name[10];
    char type[10];
    char value[10];
    char scope[10];
    int address;
};

struct table symbolTable[50];
int identifiers=0;
int address=1000, scope=0;

int istype(char *type){
    char *types[] = {"int", "float", "double", "char"};
    int n=sizeof(types)/sizeof(types[0]);
    for(int i=0;i<n;i++){
        if(strcmp(types[i],type)==0) return 1;
    }
    return 0;
}

int duplicatechecking(char *name, char *scope){
    for(int i=0;i<identifiers;i++){
        if(strcmp(symbolTable[i].name,name)==0 && strcmp(symbolTable[i].scope,scope)==0) return 1;
    }
    return 0;
}

void insert(char *name, char *type, char *value){
    char scopename[10];
    if(scope==0) strcpy(scopename,"global");
    else if(scope==1) strcpy(scopename,"local");

    if(duplicatechecking(name,scopename)){
        printf("Error: Identifier with name %s and Scope %s already defined\n",name, scopename);
        return;
    }

    strcpy(symbolTable[identifiers].name,name);
    strcpy(symbolTable[identifiers].type,type);
    strcpy(symbolTable[identifiers].scope,scopename);
    if(strcmp(value,"")==0){
        strcpy(symbolTable[identifiers].value,"-");
    }else{
        strcpy(symbolTable[identifiers].value,value);
    }
    symbolTable[identifiers].address=address;
    if(strcmp(type,"int")==0 || strcmp(type,"float")==0) address+=4;
    else if(strcmp(type,"double")==0) address+=8;
    else if(strcmp(type,"string")==0) address+=strlen(value)-2;
    else address++;
    identifiers++;
}

int main(){
    char filename[50];
    printf("Enter the filename:");
    scanf("%s",filename);
    
    FILE *fp = fopen(filename, "r");
    if(!fp){
        printf("File not found");
        return 0;
    }
    char ch, buffer[50];
    int i=0;

    int nextidentifier=0, nextval=0;
    char type[10], identifier[10];

    while((ch=fgetc(fp))!=EOF){
        if(ch=='{') scope=1;
        else if(ch=='}') scope=0;
        if(isalnum(ch) || ch=='_' || (ch=='.' && i>0 && !strchr(buffer, ch)) ||ch=='"' || ch=='\''){
            buffer[i++]=ch;
        }else{
            if(i>0){
                buffer[i]='\0';
                i=0;
                if(istype(buffer)){
                    strcpy(type, buffer);
                    nextidentifier=1;
                }else if(nextidentifier){
                    strcpy(identifier, buffer);
                    nextidentifier=0;
                    nextval=1;
                }else if(nextval){
                    insert(identifier, type, buffer);
                    nextval=0;
                }
            }
        }
    }
    fclose(fp);

    printf("%-20s %-12s %-12s %-12s %-12s\n","Name","Type", "Scope", "Value", "Address");
    for(int i=0;i<identifiers;i++){
        printf("%-20s %-12s %-12s %-12s %d\n",symbolTable[i].name,symbolTable[i].type,symbolTable[i].scope,symbolTable[i].value,symbolTable[i].address);
    }

    return 0;
}