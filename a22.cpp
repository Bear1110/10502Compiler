#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
using namespace std;

int main()
{
    string s;
    while(cin>>s){
        int i = 0;
        int j = s.length()-1;
        bool result = true;
        while( i < j){
            i++;
            j--;
            if(s.at(i) != s.at(j)){
                result = false;
                break;
            }
        }
        if(!result){
            cout<<"no"<<endl;
            continue;
        }
        cout<<"yes"<<endl;

    }

    return 0;
}
