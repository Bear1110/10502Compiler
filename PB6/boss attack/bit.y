%{
    #include <stdio.h>
    #include <stdlib.h>
    int yylex(void);
    void yyerror(const char *message);
    void checkInputNum (int num);
    extern int test = 0;
%}
%union {
    unsigned int ival;
}
%token <ival> NUM
%type <ival> formula
%type <ival> formulas
%left DIV MUTI '&' '|' '^' '-'
%left '~'
%%
lines    : formulas { test = $1; }
         ;
formulas : formula { $$ = $1;}
         ;
formula  : '&' formula formula 	   { int temp = $2 & $3; $$ = temp & 31; }
         | '|' formula formula 	   { int temp = $2 | $3; $$ = temp & 31; }
         | '^' formula formula 	   { int temp = $2 ^ $3; $$ = temp & 31; }
         | '~' formula     { int temp = ~$2;     $$ = temp & 31; }
         | DIV formula formula     { int temp = $2 & 31; $$ = temp >> $3; }
         | MUTI formula formula    { int temp = $2 & 31; $$ = temp << $3;}
         | NUM                     { checkInputNum($1);  $$ = $1;}
         | '-' NUM                 { checkInputNum(-999);}
         ;
%%
void checkInputNum (int num){
   if( num > 31 || num <0 ){
      printf("integer out of range");
      exit(0);
   }
}
void yyerror (const char *message) {
    printf ("syntax error");
    //fprintf (stderr, "%s\n", message);
    exit(0);
}
int main(int argc, char *argv[]) {
        yyparse();
        printf("%d",test);
        return 0;
}
