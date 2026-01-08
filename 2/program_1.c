#include<stdio.h>

int main(){
  char name[10]="Yashvanth";
  int p=10000,n=2;
  float r=8.9;
  float tax=9.9;
  float simple_interest=(p*n*r)/100;
  simple_interest+=tax;
  printf("Simple Interest for %s: %.2f\n",simple_interest,name);
  return 0;
}