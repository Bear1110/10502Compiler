%{
#include <stdio.h>
#include <string.h>


void yyerror(const char *message);
void type_check(int , int);
int id_check(char*);


/*****************id define varible************************/
int counter=0;
char name[100][30];
int name_value[100];

/****************************************************/



%}
%union {
	int ival;
	int tf[2];// tf[0]=0||1 (0 for int 1 for bool)   tf[1]  for assgin value   
	char *word;

}

%token <ival> NUM
%token <ival> bool_var
%token <word> WORD
%token <word> END
%token <word> MOD
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
			| STMT STMT

print_STMT	: '(' print_num expr ')'		{
												if($<tf>3[0]!=0){
													printf("%s\n","type error");
													return 0;
												}
												printf("%d",$<tf>3[1]);
											}  
			| '(' print_bool expr ')'		{
													if($<tf>3[0]!=1){
													printf("%s\n","type error");
													return 0;
													}	

													if ($<tf>3[1]==1)
														printf("%s","#t" );
													else
														printf("%s","#f" );

											}

expr		:NUM 							{$<tf>$[0]=0;$<tf>$[1]=$<ival>1;}										
			|NUM-OP
			|LOGICAL-OP
			|bool_var						{$<tf>$[0]=1;$<tf>$[1]=$<ival>1;}
						


NUM-OP		: PLUS							
			| MINUS	
			| MULTIPLY
			| MODULUS
			| GREATER
			| SMALLER
			| EQUAL


LOGICAL-OP	: AND-OP					
			| OR-OP
			| NOT-OP

/*********************************NUM-OP**********************************************/
PLUS		: '(' '+' expr expr 	 	{type_check($<tf>3[0],$<tf>4[0]);$<tf>$[0]=0;$<tf>$[1]=$<tf>3[1]+$<tf>4[1];}
			| PLUS expr 				{type_check($<tf>1[0],$<tf>2[0]);$<tf>$[0]=0;$<tf>$[1]=$<tf>1[1]+$<tf>2[1];}


expr		: PLUS ')'					{$<tf>$[1]=$<tf>1[1];}


MINUS		:'(' '-' expr expr ')'		{$<tf>$[0]=0;$<tf>$[1]=$<tf>3[1]-$<tf>4[1];}

MULTIPLY	: '(' '*' expr expr 	 	{$<tf>$[0]=0;$<tf>$[1]=$<tf>3[1]*$<tf>4[1];}
			| MULTIPLY expr 			{$<ival>$=$<ival>1*$<ival>2;}

expr		: MULTIPLY ')'				{$<tf>$[1]=$<tf>1[1];}

MODULUS		: '(' MOD expr expr ')'		{$<tf>$[0]=0;$<tf>$[1]=$<tf>3[1]%$<tf>4[1];} 


GREATER 	: '(' '>' expr expr ')'		{
											type_check($<tf>3[0],$<tf>4[0]);
											$<tf>$[0]=1;
											
											if ($<tf>3[1]>$<tf>4[1]){
												$<tf>$[1]=1;
											}
											else{
												$<tf>$[1]=0;	
											}

										}
SMALLER 	: '(' '<' expr expr ')'		{
											$<tf>$[0]=1;
											if ($<tf>3[1]<$<tf>4[1]){
												$<tf>$[1]=1;
											}
											else{
												$<tf>$[1]=0;	
											}
										}
EQUAL	 	: '(' '=' expr expr ')'		{
											$<tf>$[0]=1;
											if ($<tf>3[1]==$<tf>4[1]){
												$<tf>$[1]=1;
											}
											else{
												$<tf>$[1]=0;
											}
										}

/******************************Logical op ***************************************/
AND-OP		: '(' AND expr expr 		{
											$<tf>$[0]=1;
											if ($<tf>3[1]==$<tf>4[1]&&$<tf>3[1]==1){
												$<tf>$[1]=1;
											}
											else{
												$<tf>$[1]=0;	
											}
										}
			| AND-OP expr				{
											$<tf>$[0]=1;
											if ($<tf>1[1]==$<tf>2[1]&&$<tf>1[1]==1){
												$<tf>$[1]=1;
											}
											else{
												$<tf>$[1]=0;	
											}

										}
expr		: AND-OP')'

OR-OP		: '(' OR expr expr 			{
											$<tf>$[0]=1;
											if ($<tf>3[1]==1||$<tf>4[1]==1){
												$<tf>$[1]=1;
											}
											else{
												$<tf>$[1]=0;	
											}
										}
			| OR-OP expr				{
											$<tf>$[0]=1;
											if ($<tf>1[1]==1||$<tf>2[1]==1){
												$<tf>$[1]=1;
											}
											else{
												$<tf>$[1]=0;	
											}

										}

expr		: OR-OP')'

NOT-OP		:'(' NOT expr ')'			{
											$<tf>$[0]=1;
											$<tf>$[1]=!$<tf>3[1];

										}		
/********************************define*******************************************/

def_STMT 	:'(' define variable expr ')'	{
													if(id_check($<word>3)==-1){
															strcpy(name[counter], $<word>3);
															name_value[counter]=$<tf>4[1];
															counter++;
													}
													else{
														printf("%s","redefine is not allowed!!" );
														return 0;
													}
											}

expr		: variable						{		
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

void yyerror(const char *message)
{	
	fprintf(stderr, "%s\n",message);
}

void type_check(int type1,int type2){
	if (type1==type2){
		/*do nothing*/
	}
	else{
		printf("%s\n","error input type" );
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


int main(int argc, char *argv[])
{
	yyparse();
	return(0);
}


