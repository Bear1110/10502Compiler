%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
int yylex(void);
void yyerror(const char *message);
void type_check(int , int, int);
int id_check(char*);

/*****************id define varible************************/
int counter = 0;
char name[100][30];
int name_value[100];
//for function
int Fcounter = 0;
bool Fini = false;
char Fname[100][30];
int Fname_value[100];
/****************************************************/

%}
%union {
	int ival;
	int tf[2]; //tf[0]=0||1 (0 for int 1 for bool)   tf[1]  for assgin value   
	char *word;
}

%token <ival> NUM
%token <ival> bool_var
%token <word> WORD
%token <word> IF
%token <word> END
%token <word> MOD
%token <word> FUN
%token <word> AND
%token <word> OR
%token <word> NOT
%token <word> define
%token <word> id
%token <word> print_num
%token <word> print_bool

%left '+'
%left '(' ')'
%left '$'

%%
PROGRAM 	: STMT 							{return 0;}
STMT 		: expr
			| def_STMT
			| print_STMT
			| STMT STMT    //有這個才會輸入完一行之後繼續讀東西

print_STMT	: '(' print_num expr ')'		{
												type_check($<tf>3[0],0,0);
												printf("%d\n",$<tf>3[1]);
											}  
			| '(' print_bool expr ')'		{
												type_check($<tf>3[0],1,1);
												if ($<tf>3[1]==1)
													printf("%s\n","#t" );
												else
													printf("%s\n","#f" );
											}
expr		:NUM 							{$<tf>$[0]=0; $<tf>$[1]= $1;}
			|NUM-OP
			|LOGICAL-OP
			|bool_var						{$<tf>$[0]=1; $<tf>$[1]= $1;}
			|IF-EXP
//			|FUN-EXP
//			|FUN-CALL

NUM-OP		: PLUS							
			| MINUS	
			| MULTIPLY
			| MODULUS
			| DIVISION
			| GREATER
			| SMALLER
			| EQUAL

LOGICAL-OP	: AND-OP					
			| OR-OP
			| NOT-OP
/********************************* IF-EXP **********************************************/
IF-EXP		: '(' IF expr expr expr ')' { 
											$<tf>$[0] = ( $<tf>3[1]==1 ) ? $<tf>4[0] : $<tf>5[0];
											$<tf>$[1] = ( $<tf>3[1]==1 ) ? $<tf>4[1] : $<tf>5[1];
										}
/********************************* NUM-OP **********************************************/
PLUS		: '(' '+' expr expr 	 	{type_check($<tf>3[0],$<tf>4[0],0);$<tf>$[0]=0;$<tf>$[1]=$<tf>3[1]+$<tf>4[1];}
			| PLUS expr 				{type_check($<tf>1[0],$<tf>2[0],0);$<tf>$[0]=0;$<tf>$[1]=$<tf>1[1]+$<tf>2[1];}
expr		: PLUS ')'					{ $<tf>$[1]=$<tf>1[1]; }

MULTIPLY	: '(' '*' expr expr 	 	{type_check($<tf>3[0],$<tf>4[0],0); $<tf>$[0]=0;$<tf>$[1]=$<tf>3[1]*$<tf>4[1];}
			| MULTIPLY expr 			{type_check($<tf>1[0],$<tf>2[0],0); $<tf>$[1] = $<tf>1[1]*$<tf>2[1]; }
expr		: MULTIPLY ')'				{ $<tf>$[1]=$<tf>1[1]; }

MINUS		: '(' '-' expr expr ')'		{type_check($<tf>3[0],$<tf>4[0],0); $<tf>$[0]=0;$<tf>$[1]=$<tf>3[1]-$<tf>4[1];}
DIVISION    : '(' '/' expr expr ')'		{type_check($<tf>3[0],$<tf>4[0],0); $<tf>$[0]=0;$<tf>$[1]=$<tf>3[1]/$<tf>4[1];}
MODULUS		: '(' MOD expr expr ')'		{type_check($<tf>3[0],$<tf>4[0],0); $<tf>$[0]=0;$<tf>$[1]=$<tf>3[1]%$<tf>4[1];} 

GREATER 	: '(' '>' expr expr ')'		{
											type_check($<tf>3[0],$<tf>4[0],0);
											$<tf>$[0]=1;
											$<tf>$[1] = ($<tf>3[1] > $<tf>4[1]) ? 1 : 0;
										}
SMALLER 	: '(' '<' expr expr ')'		{
											type_check($<tf>3[0],$<tf>4[0],0);
											$<tf>$[0]=1;
											$<tf>$[1] = ($<tf>3[1] < $<tf>4[1]) ? 1 : 0;
										}
EQUAL	 	: '(' '=' expr expr ')'		{
											type_check($<tf>3[0],$<tf>4[0],0);
											$<tf>$[0]=1;
											$<tf>$[1] = ($<tf>3[1] == $<tf>4[1]) ? 1 : 0;
										}

/******************************Logical op ***************************************/
AND-OP		: '(' AND expr expr 		{
											type_check($<tf>3[0],$<tf>4[0],1);
											$<tf>$[0]=1;
											$<tf>$[1] = ($<tf>3[1]==$<tf>4[1]&&$<tf>3[1]==1) ? 1 : 0;
										}
			| AND-OP expr				{
											type_check($<tf>1[0],$<tf>2[0],1);
											$<tf>$[0]=1;
											$<tf>$[1] = ($<tf>1[1] == $<tf>2[1] && $<tf>1[1]==1) ? 1 : 0;
										}
expr		: AND-OP')'					{ $<tf>$[0]=1; $<tf>$[1]=$<tf>1[1]; }

OR-OP		: '(' OR expr expr 			{
											type_check($<tf>3[0],$<tf>4[0],1);
											$<tf>$[0]=1;
											$<tf>$[1] = ($<tf>3[1]==1||$<tf>4[1]==1) ? 1 : 0;
										}
			| OR-OP expr				{
											type_check($<tf>1[0],$<tf>2[0],1);
											$<tf>$[0]=1;
											$<tf>$[1] = ($<tf>1[1]==1||$<tf>2[1]==1) ? 1 : 0;
										}
expr		: OR-OP')'					{ $<tf>$[0]=1; $<tf>$[1]=$<tf>1[1]; }

NOT-OP		:'(' NOT expr ')'			{
											type_check($<tf>3[0],1,1);
											$<tf>$[0]=1;
											$<tf>$[1]=!$<tf>3[1];
										}
/********************************* FUN **********************************************failed/
/*FUN-EXP		: '(' FUN FUN-IDs FUN-BODY ')'
FUN-BODY    : expr
FUN-IDs		: '(' id 
			| FUN-IDs id
			| FUN-IDs ')' 
FUN-CALL    : '(' FUN-EXP PARAM ')'
//			| '(' FUN-NAME PARAM ')'
PARAM       : expr                   {
											if (!Fini){ // 表示還沒初始化過
												Fcounter = 0;
											}
											Fname_value[Fcounter++] = $<tf>1[1];
									  }
            | PARAM expr 			  {
											Fname_value[Fcounter++] = $<tf>2[1];
									  }
//FUN-NAME    : id*/
/********************************define**************************************************/

def_STMT 	:'(' define variable expr ')'	{
													if(id_check($<word>3)==-1){
															strcpy(name[counter], $<word>3);
															name_value[counter]=$<tf>4[1];
															counter++;
													}
													else{
														printf("%s\n","redefine is not allowed!!" );
														return 0;
													}
											}

expr		: variable						{//這邊是拿來當作有人呼叫一個已經宣告的東西用
													int index=id_check($<word>1);
													
													if(index==-1){
														printf("%s\n","the id hasn't been defined" );
														return 0;
													}
													else{
														$<tf>$[0]=0;
														$<tf>$[1]=name_value[index];
													}

											}
variable	: id

%%
void yyerror(const char *message){	
	fprintf(stderr, "%s\n",message);
	//printf("%s\n","syntax error" );
	exit(0);
}
void type_check(int type1,int type2,int typeWant){
	if (type1 != typeWant || type2 != typeWant){
		char *one = "number";
		char *two = "boolean";
		if(typeWant == 1){ // expect bool but get int
			one = "boolean";
			two = "number";
		}
		printf("Type Error: Expect ‘%s’ but got ‘%s’.\n",one,two);
		exit(0);
	}
}
int id_check(char *a){
	int rc=-1;
		for (int i = 0; i<100; ++i)
		{
			rc= strcmp(a,name[i]);
			if(rc==0){
				return i;
			}
		}
		return -1;
}
int main(int argc, char *argv[]){
	yyparse();
	return(0);
}