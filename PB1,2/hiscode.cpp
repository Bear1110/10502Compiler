#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <vector>
#include <time.h>

using namespace std;

void gettok();
void exprs();
void expr();
void H();
void B();
void R();
bool judge = true;
vector<char> token;
int token_i = 0;
char tok;

int main()
{
    char temp;
    while (cin.get(temp))
    {
        if (temp == '(' || temp == '[' || temp == '{' || temp == ')' || temp == ']' || temp == '}')
        {
            token.push_back(temp);
        }
        // if(temp=='\n'){  //送domjoudge記得要註解
        //     break;
        // }
    }
    if (token.size() > 1 &&  token.size()%2==0 ) //後面是防止  ()) 這種案例
    {
        while(token_i < token.size()){ //防止 )) 或是 ()))
            gettok();
            if(tok == '(' || tok =='[' || tok=='{'){
                exprs();
            }else{
                judge = false;
            }
        }
    }
    else
    {
        judge = false;
    }
    string message;
    message = (judge) ? "valid" : "error"; 
    cout<<message<<endl;
    system("pause");
    return 0;
}
void gettok()
{
    tok = token[token_i];
    token_i++;
}
void exprs()
{
    if (!judge){return;}
    expr();
    if (tok == '(' | tok == '[' || tok == '{')
    {
        exprs();
    }
    return;
}
void expr()
{
    if (tok == '('){
        H();
    }else if (tok == '['){
        R();
    }else if (tok == '{'){
        B();
    }else{
        return;
    }
}
void H()
{
    if (!judge)
    {
        return;
    }
    gettok();
    exprs();
    if (tok == ')')
    {
        gettok();
        return;
    }
    else
    {
        judge = false;
    }
}
void R()
{
    if (!judge)
    {
        return;
    }
    gettok();
    exprs();
    if (tok == ']')
    {
        gettok();
        return;
    }
    else
    {
        judge = false;
    }
}
void B()
{
    if (!judge)
    {
        return;
    }
    gettok();
    exprs();
    if (tok == '}')
    {
        gettok();
        return;
    }
    else
    {
        judge = false;
    }
}