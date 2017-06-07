%{
#include "minilisp.tab.h"
#include <string.h>
%}
seperator	[ \t\n\r]+
letter		[a-z]
digit		[0-9]

%%

{seperator}						{ }
"mod"							{ return(MOD); }
"and"							{ return(AND); }
"or"							{ return(OR); }
"not"							{ return(NOT); }
"print-num"						{ return(PRINT_NUM); }
"print-bool"					{ return(PRINT_BOOL); }
"define"						{ return(DEFINE); }
"if"							{ return(IF); }
"fun"							{ return(FUN); }
0|[1-9]{digit}*|-[1-9]{digit}*	{ yylval.ival = atoi(yytext);
								  return(NUMBER);
								}
{letter}({letter}|{digit}|"-")*	{ yylval.s = strdup(yytext);
								  return(ID);
								}
"#t"							{ yylval.ival = 1;
								  return(BOOL);
								}
"#f"							{ yylval.ival = 0;
								  return(BOOL);
								}
"+"|"-"|"*"|"/"|">"|"<"|"="		{ return(yytext[0]); }
.								{ return(yytext[0]); }

%%
