//#include<stdio.h>
//#include<stdlib.h>
#include <bits/stdc++.h>
//#define Min(a,b,c) min((a),min((b),(c)))
#define mp(a, b) make_pair((a), (b))
#define pii pair<int, int>
#define pll pair<LL, LL>
#define pb(x) push_back(x)
#define x first
#define y second
#define sqr(x) ((x) * (x))
#define EPS 1e-11
#define MEM(x) memset(x, 0, sizeof(x))
#define N 200005
#define M
#define pi 3.14159265359
using namespace std;
typedef long long LL;
int dp[1005][1005];
char c[100005];
LL DP(int l, int r)
{
    if (l > r)
	return 0;
    cout << l << " " << r << endl;
    if (dp[l][r])
	return dp[l][r];
    if (l == r)
	return dp[l][r] = 1;
    if (c[l] == c[r])
	return dp[l][r] = DP(l, r - 1) + DP(l + 1, r);
    return dp[l][r] = DP(l, r - 1) + DP(l + 1, r) - DP(l + 1, r - 1); //
}
int main()
{
    MEM(dp);
    scanf("%s", c + 1);
    // cout << c + 1;
    printf("%danswer", DP(1, strlen(c + 1)));
    system("pause");
}

/*90 110
180 220
270 330
360 440
450 550
540 660
630 770
*/
