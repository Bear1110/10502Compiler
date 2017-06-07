%{
    #include "y.tab.h"
%}
%%
[ \t\n]+	        {/* do nothing */ }
[0-9]+[0-9]*	    { yylval.ival = atoi(yytext);return(NUM); }
("-"[1-9]+[0-9]*)	{ yylval.ival = atoi(yytext);return(NUM); }
"#t"	            { yylval.ival = 1;return(bool_var);		}
"#f"            	{ yylval.ival=0;return(bool_var);	} 
"define"            { yylval.word = strdup(yytext);return(define);}
"mod"           	{yylval.word = strdup(yytext);return(MOD);}
"and"           	{yylval.word = strdup(yytext);return(AND);}
"or"            	{yylval.word = strdup(yytext);return(OR);}
"not"           	{yylval.word = strdup(yytext);return(NOT);}
"if"            	{yylval.word = strdup(yytext);return(IF);}
"fun"           	{yylval.word = strdup(yytext);return(FUN);}

"print-num"	        {yylval.word = strdup(yytext);return(print_num);}
"print-bool"        {yylval.word = strdup(yytext);return(print_bool);}
[a-zA-Z]([a-zA-Z]|"-"|[0-9])* { yylval.word = strdup(yytext); return(id); }

[*+-/(/)$/>/</=//]	{ return(yytext[0]);} 
.	{ return(yytext[0]); }
%%