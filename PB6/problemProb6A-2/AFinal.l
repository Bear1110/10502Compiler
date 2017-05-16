%{
#include "AFinal.tab.h"
int s = 0;
%}
%%

\n	{ return(0); /* EOF */ }
[ \t]+	{ s+= yyleng;/* do nothing */ }
[0-9]+	{ s+= yyleng; yylval.ival = atoi(yytext); return(NUM); }
"^T"	{ s+= yyleng; return(TRANSPOSE); }
[+\-*()\[\],]	{ s+= yyleng; yylval.ival = s;return(yytext[0]); }
.	{ return(yytext[0]); }

%%