%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <stdio.h>
    #include <string.h>
    #include <map>
    #include <string>
    #include<iostream>
    using namespace std;
    int yylex(void);
    void yyerror(const char *message);
    map<string,int> add (map<string,int> a , map<string,int> b);
    void compare (map<string,int> a , map<string,int> b);
    struct Type{
        int ival;
        string istring;
        map< string , int> m;
    };
    #define YYSTYPE Type//好了 你看這樣行不行 YYSTYPE <<< 我不用去呼叫他?? 不用 他是 yylval的型態 
%}
%token <ival> NUM
%type <m> formula
%type <m> elements
%token <istring> ELEMENT
%left '+'
%left EQUAL
%nonassoc A
%%
lines    : formula EQUAL formula { compare($1,$3); }
         ;
formula  : formula '+' formula { $$ = add($1,$3); }
         | elements { $$ = $1; }
         ;
elements : elements elements {
                                $$ = add($1,$2);
                             }
         | NUM elements {
                            map< string , int> m;
                            for (map<string , int>::iterator i = $2.begin(); i != $2.end(); i++) {
			                    m[(*i).first] = (*i).second*$1;
                            }
                            $$ = m;
                        }
         | '(' elements ')' NUM %prec A {
                                            for (map<string, int>::iterator i = $2.begin(); i != $2.end(); i++) {
			                                    $2[(*i).first] = $4*(*i).second;
                                            }
                                            $$ = $2;
                                        }
         | ELEMENT NUM { $$[$1] += $2; }
         | ELEMENT { $$[$1] += 1; }
         ;
%%
map<string,int> add (map<string,int> a , map<string,int> b){
    map< string , int> m;
    
    for (map<string, int>::iterator i = a.begin(); i != a.end(); i++) {
			m[(*i).first] += (*i).second;
    }
    for (map<string,int>::iterator i = b.begin(); i != b.end(); i++) {
			m[(*i).first] += (*i).second;
    }  
    return m;
}
void compare (map<string,int> a , map<string,int> b){
    map< string , int> m;
    for (map<string, int>::iterator i = a.begin(); i != a.end(); i++) {
	    //cout << (*i).first << " : " <<(*i).second<<endl;
        m[(*i).first] += (*i).second;
    }
    for (map<string,int>::iterator i = b.begin(); i != b.end(); i++) {
		m[(*i).first] -= (*i).second;
    }
    for (map<string,int>::iterator i = m.begin(); i != m.end(); i++) {
        if((*i).second == 0 ) continue;
		cout << (*i).first << " " <<(*i).second<<endl;
    }
}
void yyerror (const char *message) {
    cout <<"Invalid format\n";
	//fprintf (stderr, "%s\n", message);
}
int main(int argc, char *argv[]) {
        yyparse();
        return 0;
}