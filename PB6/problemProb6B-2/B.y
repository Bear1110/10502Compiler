%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <stdio.h>
    #include <string.h>
    int yylex(void);
    void yyerror(const char *message);
    int error(int i);
%}
%union {
    int ival;
    char *istring;
    struct chemistry
    {
        map< char*, int> mapa;
    }m;
}
%token <ival> NUM
%type <m> formula
%type <m> elements
%token <istring> element
%left<ival> '+'
%left EQUAL

%%
lines    : formula EQUAL formula { printf("Accepted"); }
         ;
formula  : elements '+' elements { $$ = $1; }
         | NUM elements { $$ = $2; }
         | elements { $$ = $1; }
         ;
elements : element elements { $$ = $1; }
         | element NUM { $$.mapa[$1] += $2; }
         | element { $$.mapa[$1] += 1; }
         ;
%%
void yyerror (const char *message) {
	fprintf (stderr, "%s\n", message);
}
int main(int argc, char *argv[]) {
        yyparse();
        return 0;
}