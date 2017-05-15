#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
using namespace std;

int main()
{
     const int arsize=20;
  char name1[arsize];
  char name2[arsize];
  int age;
  cout<<"what is your first name?";

//   cin.getline(name1,arsize);
 cin.get(name1,arsize).get();  // cin.get()可用來裝載空enter
 if()
  
  cout<<"what is your last name?";
  cin.get(name2,arsize);
  
  cout<<"what is your age?";
  cin>>age;
  
  cout<<"name:"<<name1<<','<<name2<<";\n"
      <<"age:"<<age<<'\n';
    
    system("pause");
    return 0;
}
