%{
#include <stdio.h>
#include <string.h>
void yyerror(const char *message);

typedef struct nodes {
	char *type;
	char *name;
	int value;
	struct nodes *next;
	struct nodes *funVar;
	struct nodes *funBody;
} LIST;

LIST *global = NULL;
LIST *newNode(char *type);
void addNode(LIST *list, LIST *node);
void removeNode(LIST *list);
LIST *calculate(LIST *node);
LIST *replaceParams(LIST *list, LIST *params);
%}

%union {
	int ival;
	char *s;
	struct nodes *list;
}
%token<ival> NUMBER BOOL
%token<s> ID
%type<list> stmts stmt exp exps print-stmt def-stmt
%type<list> num-op plus minus multiply divide modulus greater smaller equal
%type<list> logical-op and-op or-op not-op
%type<list> fun-exp fun-ids ids fun-body fun-call params
%type<list> if-exp test-exp then-exp else-exp
%left MOD AND OR NOT PRINT_NUM PRINT_BOOL DEFINE IF FUN

%%

line		: stmts
			;
stmts		: stmt stmts
			| stmt
			;
stmt		: exp							{ free($1); }
			| def-stmt
			| print-stmt
			;
print-stmt	: '(' PRINT_NUM exp ')'			{ printf("%d\n", calculate($3)->value); }
			| '(' PRINT_BOOL exp ')'		{ int result = calculate($3)->value;
											  if(result == 0) {
												printf("#f\n");
											  }
											  else if(result == 1) {
												printf("#t\n");
											  }
											  else {
												printf("semantic error\n");
												return 0;
											  }
											}
			;
exps		: exp exps						{ $$ = $1;
											  addNode($$, $2);
											}
			| exp
			;
exp			: BOOL							{ $$ = newNode("bool");
											  $$->value = $1;
											}
			| NUMBER						{ $$ = newNode("number");
											  $$->value = $1;
											}
			| ID							{ $$ = newNode("variable");
											  $$->name = strdup($1);
											}
			| num-op
			| logical-op
			| fun-exp
			| fun-call
			| if-exp
			;
num-op		: plus
			| minus
			| multiply
			| divide
			| modulus
			| greater
			| smaller
			| equal
			;
	plus		: '(' '+' exp exps ')'		{ $$ = newNode("plus");
											  addNode($$, $3);
											  addNode($$, $4);
											  addNode($$, newNode("end"));
											}
				;
	minus		: '(' '-' exp exp ')'		{ $$ = newNode("minus");
											  addNode($$, $3);
											  addNode($$, $4);
											}
				;
	multiply	: '(' '*' exp exps ')'		{ $$ = newNode("multiply");
											  addNode($$, $3);
											  addNode($$, $4);
											  addNode($$, newNode("end"));
											}
				;
	divide		: '(' '/' exp exp ')'		{ $$ = newNode("divide");
											  addNode($$, $3);
											  addNode($$, $4);
											}
				;
	modulus		: '(' MOD exp exp ')'		{ $$ = newNode("modulus");
											  addNode($$, $3);
											  addNode($$, $4);
											}
				;
	greater		: '(' '>' exp exp ')'		{ $$ = newNode("greater");
											  addNode($$, $3);
											  addNode($$, $4);
											}
				;
	smaller		: '(' '<' exp exp ')'		{ $$ = newNode("smaller");
											  addNode($$, $3);
											  addNode($$, $4);
											}
				;
	equal		: '(' '=' exp exps ')'		{ $$ = newNode("equal");
											  addNode($$, $3);
											  addNode($$, $4);
											  addNode($$, newNode("end"));
											}
				;
logical-op	: and-op
			| or-op
			| not-op
			;
	and-op		: '(' AND exp exps ')'		{ $$ = newNode("and");
											  addNode($$, $3);
											  addNode($$, $4);
											  addNode($$, newNode("end"));
											}
				;
	or-op		: '(' OR exp exps ')'		{ $$ = newNode("or");
											  addNode($$, $3);
											  addNode($$, $4);
											  addNode($$, newNode("end"));
											}
				;
	not-op		: '(' NOT exp ')'			{ $$ = newNode("not");
											  addNode($$, $3);
											}
				;
def-stmt		: '(' DEFINE ID exp ')'		{ if(strcmp($4->type, "function") != 0) {
												LIST *n = newNode("variable");
												n->name = strdup($3);
												n->value = calculate($4)->value;
												free($4);
												if(global == NULL) {
													global = n;
												}
												else {
													addNode(global, n);
												}
											  }
											  else {
												$4->name = strdup($3);
												if(global == NULL) {
													global = $4;
												}
												else {
													addNode(global, $4);
												}
											  }
											}
				;
fun-exp			: '(' FUN fun-ids fun-body ')'	{ LIST *n = newNode("function");
												  n->funVar = $3;
												  n->funBody = $4;
												  $$ = n;
												}
				;
fun-ids			: '(' ids ')'				{ $$ = $2; }
				| '(' ')'					{ $$ = NULL; }
				;
ids				: ID ids					{ $$ = newNode("variable");
											  $$->name = strdup($1);
											  addNode($$, $2);
											}
				| ID						{ $$ = newNode("variable");
											  $$->name = strdup($1);
											}
				;
fun-body		: exp
				;
fun-call		: '(' fun-exp params ')'	{ $$ = $2;
											  replaceParams($$, $3);
											}
				| '(' fun-exp ')'			{ $$ = $2; }
				| '(' ID params ')'			{ LIST *current = global;
											  while(current != NULL) {
												if(strcmp(current->name, $2) == 0) {
													$$ = current;
													break;
												}
												current = current->next;
											  }
											  if(current == NULL) {
												printf("semantic error\n");
												return 0;
											  }
											  replaceParams($$, $3);
											}
				| '(' ID ')'				{ LIST *current = global;
											  while(current != NULL) {
												if(strcmp(current->name, $2) == 0) {
													$$ = current;
													break;
												}
												current = current->next;
											  }
											  if(current == NULL) {
												printf("semantic error\n");
												return 0;
											  }
											}
				;
params			: exp params				{ $$ = calculate($1);
											  addNode($$, $2);
											}
				| exp						{ $$ = calculate($1); }
				;
if-exp			: '(' IF test-exp then-exp else-exp ')'
											{ int result = calculate($3)->value;
											  if(result == 1) {
												$$ = $4;
											  }
											  else if(result == 0) {
												$$ = $5;
											  }
											  else {
											    printf("semantic error\n");
												return 0;
											  }
											}
				;
test-exp		: exp
				;
then-exp		: exp
				;
else-exp		: exp
				;
				
%%

void yyerror(const char *message) {
	fprintf(stderr, "%s\n", message);
}

LIST *newNode(char *type) {
	LIST *n;
	n = (LIST *)malloc(sizeof(LIST));
	n->type = strdup(type);
	n->next = NULL;
	return n;
}

void addNode(LIST *list, LIST *node) {
	LIST *current = list;
	while(current->next != NULL) {
		current = current->next;
	}
	current->next = node;
}

void removeNode(LIST *list) {
	LIST *temp = list->next->next;
	free(list->next);
	list->next = temp;
}

LIST *calculate(LIST *node) {
	if(strcmp(node->type, "variable") == 0) {
		LIST *current = global;
		while(current != NULL) {
			if(strcmp(current->name, node->name) == 0) {
				node->value = current->value;
				break;
			}
			current = current->next;
		}
		if(current == NULL) {
			printf("semantic error\n");
			return 0;
		}
	}
	else if(strcmp(node->type, "plus") == 0) {
		node->type = "number";
		node->value = 0;
		while(strcmp(node->next->type, "end") != 0) {
			node->value += calculate(node->next)->value;
			removeNode(node);
		}
		removeNode(node);
		return node;
	}
	else if(strcmp(node->type, "minus") == 0) {
		node->type = "number";
		node->value = calculate(node->next)->value - calculate(node->next->next)->value;
		removeNode(node);
		removeNode(node);
		return node;
	}
	else if(strcmp(node->type, "multiply") == 0) {
		node->type = "number";
		node->value = calculate(node->next)->value;
		removeNode(node);
		while(strcmp(node->next->type, "end") != 0) {
			node->value *= calculate(node->next)->value;
			removeNode(node);
		}
		removeNode(node);
		return node;
	}
	else if(strcmp(node->type, "divide") == 0) {
		node->type = "number";
		node->value = calculate(node->next)->value / calculate(node->next->next)->value;
		removeNode(node);
		removeNode(node);
		return node;
	}
	else if(strcmp(node->type, "modulus") == 0) {
		node->type = "number";
		node->value = calculate(node->next)->value % calculate(node->next->next)->value;
		removeNode(node);
		removeNode(node);
		return node;
	}
	else if(strcmp(node->type, "greater") == 0) {
		node->type = "bool";
		node->value = calculate(node->next)->value > calculate(node->next->next)->value;
		removeNode(node);
		removeNode(node);
		return node;
	}
	else if(strcmp(node->type, "smaller") == 0) {
		node->type = "bool";
		node->value = calculate(node->next)->value < calculate(node->next->next)->value;
		removeNode(node);
		removeNode(node);
		return node;
	}
	else if(strcmp(node->type, "equal") == 0) {
		node->type = "bool";
		node->value = 1;
		while(strcmp(node->next->next->type, "end") != 0) {
			if(calculate(node->next)->value != calculate(node->next->next)->value) {
				node->value = 0;
			}
			removeNode(node);
		}
		removeNode(node);
		return node;
	}
	else if(strcmp(node->type, "and") == 0) {
		node->type = "bool";
		node->value = 1;
		while(strcmp(node->next->type, "end") != 0) {
			if(calculate(node->next)->value != 1) {
				node->value = 0;
			}
			removeNode(node);
		}
		removeNode(node);
		return node;
	}
	else if(strcmp(node->type, "or") == 0) {
		node->type = "bool";
		node->value = 0;
		while(strcmp(node->next->type, "end") != 0) {
			if(calculate(node->next)->value == 1) {
				node->value = 1;
			}
			removeNode(node);
		}
		removeNode(node);
		return node;
	}
	else if(strcmp(node->type, "not") == 0) {
		node->type = "bool";
		node->value = !calculate(node->next)->value;
		removeNode(node);
		return node;
	}
	else if(strcmp(node->type, "function") == 0) {
		if(node->funVar != NULL) {
			LIST *current = node->funBody;
			while(current != NULL) {
				if(strcmp(current->type, "variable") == 0) {
					LIST *current2 = node->funVar;
					while(current2 != NULL) {
						if(strcmp(current->name, current2->name) == 0) {
							current->type = current2->type;
							current->value = current2->value;
							break;
						}
						current2 = current2->next;
					}
				}
				current = current->next;
			}
		}
		node->type = "number";
		node->value = calculate(node->funBody)->value;
		return node;
	}
	return node;
}

LIST *replaceParams(LIST *list, LIST *params) {
	LIST *current = list->funVar;
	LIST *current2 = params;
	while(current != NULL) {
		if(current2 == NULL) {
			printf("semantic error\n");
			return 0;
		}
		current->type = current2->type;
		current->value = current2->value;
		current = current->next;
		current2 = current2->next;
	}
	if(current2 != NULL) {
		printf("semantic error\n");
		return 0;
	}
	free(params);
	return list;
}

int main(int argc, char *argv[]) {
	yyparse();
	free(global);
	return 0;
}
