%{
#include "y.tab.h"
int site = 0;
%}
%%

\n	{ return(0); /* EOF */ }
[ \t]+	{ /* do nothing */ }
[0-9]+	{ site+= yyleng; yylval.ival = atoi(yytext); return(NUM); }
"+"|"-"|"*"|"^"|"T"|"("|")"|"["|"]"|","	{ site+= yyleng; yylval.ival = site;return(yytext[0]); }
.	{ return(yytext[0]); }

%%