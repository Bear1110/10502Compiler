%{
#include "y.tab.h"
%}
element [A-Z][a-z]*
equal "->"
%%
[0-9]+	{ yylval.ival = atoi(yytext); return(NUM); }
equal	{ return(EQUAL); }
element	{ printf("%s",yytext); yylval.istring = strdup(yytext);return(element); }
+	    { return(yytext[0]); }
\n	    { return(0); /* EOF */ }
[ \t]+	{ /* do nothing */ }
.	    { /*return(yytext[0]);*/ }

%%