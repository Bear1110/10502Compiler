%{
    #include <stdio.h>
    #include <string.h>
    int check=0;
    int temp=0;
    
    int yylex(void);
    void yyerror(const char *message);
    %}
%union {
    int ival;
}

%token <ival> INUMBER
%token <ival> plus
%token <ival> minus
%token <ival> multi
%type <ival> exprs
%type <ival> matrix_mut
%type <ival> matrix_plus
%left puls minus
%left multi
%left UMINUS
%nonassoc NON


%%
line    : matrix_plus                  { if(check==0){printf("Accepted");} }
;
exprs   :'[' INUMBER ',' INUMBER ']' {$$=$2*100000+$4;}
        | exprs '^''T' %prec UMINUS {temp=($1%100000)*100000;$$=temp+($1/100000);}
        | '(' matrix_plus ')' %prec NON {$$=$2;}
;

matrix_mut :  matrix_mut multi exprs {if($1%100000!=($3-$3%100000)/100000){printf("Semantic error on col %d\n",$2);return(0);}if($1%100000*100000==$3-$3%100000){$$=$1-$1%100000+$3%100000;}}
            | exprs {$$=$1;}
;
matrix_plus : matrix_plus plus matrix_mut  {if($1!=$3){printf("Semantic error on col %d\n",$2);return(0);}}
            | matrix_plus minus matrix_mut {if($1!=$3){printf("Semantic error on col %d\n",$2);return(0);}}
            | matrix_mut
;
%%
void yyerror (const char *message){
    fprintf (stderr, "%s\n",message);
}

int main(int argc, char *argv[]) {
    yyparse();
    return(0);
}

