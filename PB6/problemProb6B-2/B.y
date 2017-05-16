%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <stdio.h>
    #include <string.h>
    #include <map> 
    #include <string>
    using namespace std;
    int yylex(void);
    void yyerror(const char *message);
    map<string,int> add (map<string,int> a , map<string,int> b);
    struct Type{
        int ival;
        char *istring;
        map< string , int> m;
        /*struct chemistry
        {
            map< char*, int> mapa;
        }m;*///其實不用嘉這個  上面那個就行了? 可是我這個是要實作ㄟ? 等下我看看
    };
    #define YYSTYPE Type //好了 你看這樣行不行 YYSTYPE <<< 我不用去呼叫他?? 不用 他是 yylval的型態 
%}
%union {
}
%token <ival> NUM
%type <m> formula
%type <m> elements
%token <istring> element
%left<ival> '+'
%left EQUAL

%%
lines    : formula EQUAL formula { printf("Accepted"); }
         ;
formula  : elements '+' elements { $$ = $1; }
         | NUM elements { $$ = $2; }
         | elements { $$ = $1; }
         ;
elements : element elements { 
                                $$ = $1; 
                            }
         | element NUM { $$.[$1] += $2; } //這邊還沒寫完 我後面  這樣用就好啦
         | element { $$.[$1] += 1; }
         ;
%%
map<string,int> add (map<string,int> a , map<string,int> b){

}
void yyerror (const char *message) {
	fprintf (stderr, "%s\n", message);
}
int main(int argc, char *argv[]) {
        yyparse();
        return 0;
}