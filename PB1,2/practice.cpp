#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
using namespace std;

class Stack
{
  private:
    char *p;
    int length;

  public:
    Stack(int = 0);
    ~Stack();

    int top;
    void push(char);
    char pop();
    void display();
};
Stack::Stack(int size)
{
    top = -1;
    length = size;
    if (size == 0)
        p = 0;
    else
        p = new char[length];
}

Stack::~Stack()
{
    if (p != 0)
        delete[] p;
}

void Stack::push(char elem)
{
    if (top == (length - 1)) //If the top reaches to the maximum stack size
    {
        // cout<<"\nCannot push "<<elem<<", Stack full"<<endl;
        return;
    }
    else
    {
        top++;
        // cout<<elem<<"write"<<endl;
        p[top] = elem;
    }
}
char Stack::pop()
{
    if (p == 0 || top == -1)
    {
        // cout<<"Stack empty!";
        return -1;
    }
    char ret = p[top];
    top--;
    return ret;
}

void Stack::display()
{
    for (int i = 0; i <= top; i++)
        cout << p[i] << " ";
    cout << top << "<<<top" << endl;
}
//------------------------------------------------------------------------
int main()
{
    Stack stk(100);
    char temp;

    while (cin.get(temp))
    {
        if (temp == ')')
        {
            char tempp = stk.pop();
            if (tempp != '(')
            {
                cout << "error";
                system("pause");
                return 0;
            }
        }
        else if (temp == ']')
        {
            char tempp = stk.pop();
            if (tempp != '[')
            {
                cout << "error";
                system("pause");
                return 0;
            }
        }
        else if (temp == '}')
        {
            char tempp = stk.pop();
            if (tempp != '{')
            {

                cout << "error";
                system("pause");
                return 0;
            }
        }
        else if (temp == '(' || temp == '{' || temp == '[')
        {
            stk.push(temp);
        }
        // stk.push(temp);
    }
    stk.display();
    if (stk.top == -1)
        cout << "valid";
    else
        cout << "error";
    system("pause");
    return 0;
}
