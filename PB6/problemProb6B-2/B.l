%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <map>
    #include <string>
    using namespace std;
    struct Type{
        int ival;
        string istring;
        map< string , int> m;
    };
    #define YYSTYPE Type// 這邊類似 unio的功能 貌似 C++ 不能用 union
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