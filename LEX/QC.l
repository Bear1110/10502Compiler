%{
%}
head 0[Xx]
data [0-9A-Fa-f]
answer ^[ ]*{head}{data}{1,6}$
space [^{head}]
eol \n
%%
{space} {}
{answer} {
            char keys[] = " ";
            while(strcspn (yytext,keys) == 0){
                memmove(&yytext[0], &yytext[1], strlen(yytext));
            }
            printf("%s\n",yytext);
        }
{eol} {}
. {}
%%
int main(int argc, char *argv[]) {
    yylex();
    return(0);
}