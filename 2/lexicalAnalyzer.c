#include<stdio.h>
#include<ctype.h>
#include<string.h>

int keyword(char *word){
  char *keywords[]={
    "int","float","double","char","if","else","while","for","return","void","break","continue","sizeof"
  };
  int n=sizeof(keywords)/sizeof(keywords[0]);
  for(int i=0;i<n;i++){
    if(strcmp(word,keywords[i])==0){
      return 1;
    }
  }
  return 0;
}

int operator(char ch){
  char operators[]="+-*/=%<>!&|";
  int n=sizeof(operators);
  for(int i=0;i<n;i++){
    if(ch==operators[i]){
      return 1;
    }
  }
  return 0;
}

int specialSymbol(char ch){
  char symbols[]="(){}[],;";
  int n=sizeof(symbols);
  for(int i=0;i<n;i++){
    if(ch==symbols[i]){
      return 1;
    }
  }
  return 0;
}

int main(){
  FILE *fp;

  printf("Enter File Name: ");
  char filename[50];
  scanf("%s",filename);

  fp=fopen(filename,"r");

  if(!fp){
    printf("File not Found");
    return 0;
  }

  char ch;
  char buffer[50];
  int i=0;

  while((ch=fgetc(fp))!=EOF){

    if(isalnum(ch) || ch=='_' || (ch=='.' && i>0 && !strchr(buffer,'.'))){
      buffer[i++]=ch;
    }
    else{
      if(i>0){
        buffer[i]='\0';
        i=0;
        if(keyword(buffer)){
          printf("Lexeme: %s [Keyword]\n",buffer);
        }
        else if(isdigit(buffer[0])){
          printf("Lexeme: %s [Constant]\n",buffer);
        }
        else{
          printf("Lexeme: %s [Identifier]\n",buffer);
        }
      }
      if(operator(ch)){
    
        char next=fgetc(fp);

        if((ch=='+' && next=='+') || (ch=='-' && next=='-') || (ch=='=' && next=='=') || (ch=='>' && next=='=') || (ch=='<' && next=='=') || (ch=='!' && next=='=') || (ch=='+' && next=='=') || (ch=='-' && next=='=') || (ch=='*' && next=='=') || (ch=='/' && next=='=') || (ch=='&' && next=='&') || (ch=='|' && next=='|')){
          printf("Lexeme: %c%c [Operator]\n",ch,next);
        }else{
          printf("Lexeme: %c [Operator]\n",ch);
          ungetc(next,fp);
        }
      }
      else if(ch=='"'){
        int j=0;
        buffer[j++]=ch;
        while((ch=fgetc(fp))!='"' && ch!=EOF){
          buffer[j++]=ch;
        }
        buffer[j++]='"';
        buffer[j]='\0';
        printf("Lexeme: %s [String Literal]\n",buffer);
      }
      else if (ch=='\''){
        char c=fgetc(fp);
        fgetc(fp);
        printf("Lexeme: '%c' [Character Constant]\n",c);
      }
      else if(specialSymbol(ch)){
        printf("Lexeme: %c [Special Symbol]\n",ch);
      }
    }
  }
  fclose(fp);
  return 0;
}