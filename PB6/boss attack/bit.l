%{
    #include "bit.tab.h"
%}
%%
[0-9]{1,2}     { yylval.ival = atoi(yytext); return(NUM); }
"<< "          { return(MUTI); }
">> "          { return(DIV); }
"-"            { return(yytext[0]);  }
"& "|"^ "|"| "|"~ " { return(yytext[0]); }
[ \t]+	  {  }
\n	      {  return(0); /* EOF */ }
.	      {  }
%%
