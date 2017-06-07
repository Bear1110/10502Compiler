%{
  char *array[10][4];
  unsigned int i = 0,j = 0;
%}
word ^( [0-9][0-9] | 1[0-9][0-9] | 2[0-5][0-5] )
eol \n
%%
{word} { array[i][j] = strdup(yytext);j++;}
{eol} {j=0;i++;}
. {}
%%
int main(int argc, char *argv[]) {
    yylex();
    return(0);
}
