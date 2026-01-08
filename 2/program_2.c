#include<stdio.h>

int main(){
  int a,b;
  int choice;
  int result=0;
  char option='y';

  while(option!='n'){
    printf("Simple Calculator\n");
    printf("1. Addition\n");
    printf("2. Subtraction\n");
    printf("3. Multiplication\n");
    printf("4. Division\n");
    printf("Enter your choice (1-4): ");
    scanf("%d",&choice);
    printf("Enter two Numbers: ");
    scanf("%d %d",&a,&b);

    if(choice==1){
      result=a+b;
      printf("Result: %d\n",result);
    }
    else if(choice==2){
      result=a-b;
      printf("Result: %d\n",result);
    }
    else if(choice==3){
      result=a*b;
      printf("Result: %d\n",result);
    }
    else if(choice==4){
      if(b!=0){
        result=a/b;
        printf("Result: %d\n",result);
      }
      else{
        printf("Error: Division by zero is not allowed.\n");
      }
    }
    else{
      printf("Invalid Choice\n");
    }
    printf("Do you want to continue (y/n)? ");
    scanf(" %c",&option);
  }
  return 0;
}