#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
using namespace std;

int convertToASCII(string letter)
{
    int test = 0;
    for (int i = 0; i < letter.length(); i++)
    {
        char x = letter.at(i);
        test += int(x);
    }
    return test;
}
bool convertToASCIIForInt(string letter)
{
    for (int i = 0; i < letter.length(); i++)
    {
        char x = letter.at(i);
        if (i == 0 || i == letter.length() - 1)
        {
            if (int(x) != 34)
            {
                // cout<<"不是 \"";
                return false;
            }
        }
        else
        {
            if ((int(x) >= 48 && int(x) <= 57) || (int(x) >= 65 && int(x) <= 90) || (int(x) >= 97 && int(x) <= 122))
            {
            }
            else
            {
                // cout<<i<<" "<<int(x)<<"Not [a-z|A-Z|0-9]";
                return false;
            }
        }
    }
    return true;
}
string *explode(char input[])
{
    const char *d = " ,*";
    char *p;
    p = strtok(input, d);
    string *s;
    s = new string[10];
    int i = 0;
    while (p)
    {
        s[i] = p;
        p = strtok(NULL, d);
        i++;
    }
    return s;
}
bool check(string *str,string outputVar) //檢查格式
{
    int first = convertToASCII(str[0]); ///////////////第一
    if (first != 115 && first != 112)
    {
        // cout << "valid input111111111111111" << endl;
        return false;
    }

    int var = convertToASCII(str[1]); ///////////////第二
    if (var == 115 || var ==112 || var < 97 || var > 122)
    {
        // cout << "valid input2222222222" << endl;
        return false;
    }

    /////////////// 第三個
    if (first == 115)//s
    { 
        if (str[2].at(0) != '"' || str[2].at(str[2].length() - 1) != '"')
        {
            // cout << "valid inputHH" << endl;
            return false;
        }
        if (!convertToASCIIForInt(str[2]))
        {
            // cout << "valid inputssssssssssssssssssss" << endl;
            return false;
        }
    }
    else if (first == 112)
    { ///////////p
        if (str[1] != outputVar)
        {
            // cout << "valid inputaaaaaaaaaaaaaaaaaaaaa" << endl;
            return false;
        }
    }
    return true;
}
void print (string *str){
    int first = convertToASCII(str[0]); ///////////////第一
    if (first == 115 || first == 112)
    {
        if(first==115){
            cout << "strdcl s" << endl;
        }
        else{
            cout << "print p" << endl;
        }
    }
    int var = convertToASCII(str[1]); ///////////////第二
    if (var != 115 && var >= 97 && var <= 122)
    {
        cout << "id " << str[1] << endl;
    }
    /////////////// 第三個
    if (first == 115)//s
    { 
        if (convertToASCIIForInt(str[2]))
        {
            cout << "quote \""<<endl;
            cout << "string ";
            for (int i = 1; i < (str[2].length()-1) ; i++){
                cout << str[2].at(i);
            }
            cout <<endl<< "quote \""<<endl;
        }
    }
}
int main()
{
    char input1[30];
    cin.getline(input1, 30);
    char input2[30];
    cin.getline(input2, 30);
    string *str1 = explode(input1);
    string *str2 = explode(input2);
    string outputvar = str1[1];
    if( check(str1,outputvar) && check(str2,outputvar) ){
        print(str1);
        print(str2);
    }else{
        cout<<"valid input";
    }
    
    system("pause");
    return 0;
}
