%{
#include "ch6.tab.h"
int now=0;

%}
%%
\n {return(0);}
[\t] {}
[0-9]+ {now=now+yyleng;yylval.ival=atoi(yytext);return(INUMBER);}
"+" {now=now+1;yylval.ival=now;return(plus);}
"-" {now=now+1;yylval.ival=now;return(minus);}
"*" {now=now+1;yylval.ival=now;return(multi);}
" " {now=now+1;}
. {now=now+1;return yytext[0];}
%%

