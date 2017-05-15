%{
#include "ch6_A.tab.h"
int pos = 0;
%}

%%

\n	{ return(0); }
[ \t]+	{ pos += yyleng; }
[0-9]+	{ pos += yyleng; yylval.ival = atoi(yytext); return(INUMBER); }
"^T"	{ pos += yyleng; return(TRANSPOSE); }
"+"	{ pos++; yylval.ival = pos; return(ADD); }
"-"	{ pos++; yylval.ival = pos; return(SUB); }
"*"	{ pos++; yylval.ival = pos; return(MUL); }
"("|")"|"["|"]"|"."	{ pos++; return(yytext[0]); }
.	{ pos++; return(yytext[0]); }

%%
