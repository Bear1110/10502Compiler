%{
  char *array[10][4];
  unsigned int i = 0,j = 0;
%}
word [a-zA-Z0-9]+
eol \n
%%
{word} { array[i][j] = strdup(yytext);j++;}
{eol} {j=0;i++;}
. {}
%%
int main(int argc, char *argv[]) {
    yylex();
    for(int k = 0; k < i; k++) {
      if(strcmp(array[k][2],"noodles")==0){
        for(int l = 0; l < 4; l++) {
            printf("%s ",array[k][l]);
        }
        printf("\n");
      }
    }
    return(0);
}
