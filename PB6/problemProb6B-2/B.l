%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <map> 
    #include <string>
    using namespace std;
    int yylex(void);
    void yyerror(const char *message);
    map<string,int> add (map<string,int> a , map<string,int> b);
    struct Type{
        int ival;
        string istring;
        map< string , int> m;
    };
    #define YYSTYPE Type//好了 你看這樣行不行 YYSTYPE <<< 我不用去呼叫他?? 不用 他是 yylval的型態
    #include "B.tab.h"
%}
element [A-Z][a-z]*
%%
\n	      {  return(0); /* EOF */ }
[0-9]+	  {  yylval.ival = atoi(yytext); return(NUM); }
"->"      { return(EQUAL); }
{element} { yylval.istring = strdup(yytext); return(ELEMENT);}
"+"|"("|")" { return(yytext[0]); }
[ \t]+	  { /* do nothing */ }
.	      { /*return(yytext[0]);*/ }
%%