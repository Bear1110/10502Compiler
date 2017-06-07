#include<bits/stdc++.h>
//#define Min(a,b,c) min((a),min((b),(c)))
#define mp(a,b) make_pair((a),(b))
#define pii pair<int,int>
#define pll pair<LL,LL>
#define pb(x) push_back(x)
#define x first
#define y second
#define sqr(x) ((x)*(x))
#define EPS 1e-11
//#define N 200005
#define M
#define pi 3.14159265359
using namespace std;
typedef long long LL;
char c[1000000];
int idx;
vector<string> ans;
bool num(){
	while(c[idx]<=32)idx++;
	if(c[idx]>='0'&&c[idx]<='9'){
		string s="num ";
		while(c[idx]>='0'&&c[idx]<='9')s+=c[idx],idx++;
		ans.pb(s);
		return true;
	}
	return false;
}
bool fnName(){
	while(c[idx]<=32)idx++;
	if((c[idx]>='A'&&c[idx]<='Z')||(c[idx]>='a'&&c[idx]<='z')){
		string s="fnName ";
		while((c[idx]>='A'&&c[idx]<='Z')||(c[idx]>='a'&&c[idx]<='z'))s+=c[idx],idx++;
		ans.pb(s);
		return true;
	}
	return false;
}
bool leftParen(){
	while(c[idx]<=32)idx++;
	if(c[idx]=='('){
		string s="leftParen (";
		ans.pb(s);
		idx++;
		return true;
	} 
	return false;
}
bool rightParen(){
	while(c[idx]<=32)idx++;
	if(c[idx]==')'){
		string s="rightParen )";
		ans.pb(s);
		idx++;
		return true;
	} 
	return false;
}
bool Func();
bool Arg(){
	int i=idx;
	if(num())
	return true;
	idx=i;
	if(Func())
	return true;
	return false;
} 
bool Args(){
	int i=idx;
	vector<string> temp=ans;
	if(Arg()&&Args())
	return true;
	idx=i;
	ans=temp;
	return true;
}
bool Func(){
	if(leftParen()&&fnName()&&Args()&&rightParen())
		return true;
	return false;
}
bool Stmt(){
	if(Func())
		return true;
	return false;
}
bool Proc(){
	if(Stmt())
		return true;
	return false;
}
int main(){
	idx=0;
	int i=0;
	while(scanf("%c",&c[i++])!=EOF);
	if(Proc()){
		for(int j=0;j<ans.size();j++)
		cout<<ans[j]<<endl;
	}
	else{
		printf("Invalid input\n");
	}
}/**/
