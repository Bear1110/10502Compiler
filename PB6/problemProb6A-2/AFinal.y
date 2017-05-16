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
    struct martix
    {
        int col;
        int row;
    }m;
}
%token <ival> NUM
%type <m> expr
%left<ival> '+' '-'
%left<ival> '*'
%left TRANSPOSE
%nonassoc B
%nonassoc A

%%

line    : expr                  { printf("Accepted"); }
	    ;
expr    : expr '+' expr         { if($1.row==$3.row && $1.col==$3.col){ $$ = $1; }else{return error($2);} }
    	| expr '-' expr         { if($1.row==$3.row && $1.col==$3.col){ $$ = $1; }else{return error($2);} }
        | expr '*' expr         { if($1.col == $3.row){ $1.col=$3.col; $$ = $1;  }else{return error($2);} }
        | '(' expr ')' %prec A  { $$ = $2; }
        | expr TRANSPOSE        {
                                    int temp = $1.row;
                                    $1.row = $1.col;
                                    $1.col = temp;                                         
                                    $$ = $1;
                                }
        | '[' NUM ',' NUM ']' %prec B {
                                    $$.row = $2;
                                    $$.col = $4;
                                }
        ;
%%
int error(int i){
    printf ("Semantic error on col %d\n",i);
    return 0;
}
void yyerror (const char *message) {
	fprintf (stderr, "%s\n", message);
}
int main(int argc, char *argv[]) {
        yyparse();
        return 0;
}