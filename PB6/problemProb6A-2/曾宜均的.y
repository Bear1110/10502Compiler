%{
#include <stdio.h>
#include <string.h>
void yyerror(const char *message);
%}
%union {
	int ival;
	int dim[2];
}
%token<ival> INUMBER
%type<dim> expr matrix
%left<ival> ADD SUB
%left<ival> MUL
%right TRANSPOSE

%%

line	: expr			{ printf("Accepted"); }
	;
expr	: expr ADD expr		{ if( $1[0] != $3[0] || $1[1] != $3[1] ) {
				    printf("Semantic error on col %d\n", $2);
				    return 0; }
				  else { $$[0] = $1[0]; $$[1] = $1[1]; }
				}
	| expr SUB expr		{ if( $1[0] != $3[0] || $1[1] != $3[1] ) {
				    printf("Semantic error on col %d\n", $2);
				    return 0; }
				  else { $$[0] = $1[0]; $$[1] = $1[1]; }
				}
	| expr MUL expr		{ if( $1[1] != $3[0] ) {
				    printf("Semantic error on col %d\n", $2);
				    return 0; }
				  else { $$[0] = $1[0]; $$[1] = $3[1]; }
				}
	| '(' expr ')'		{ $$[0] = $2[0]; $$[1] = $2[1]; }
	| expr TRANSPOSE	{ $$[0] = $1[1]; $$[1] = $1[0]; }
	| matrix		{ $$[0] = $1[0]; $$[1] = $1[1]; }
	;
matrix	: '[' INUMBER ',' INUMBER ']'	{ $$[0] = $2; $$[1] = $4; }
	;

%%

void yyerror (const char *message) {
	fprintf (stderr, "%s\n", message);
}
int main(int argc, char *argv[]) {
	yyparse();
	return 0;
}
