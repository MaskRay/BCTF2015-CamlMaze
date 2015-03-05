#include <unistd.h>
#include <algorithm>
#include <ctime>
#include <climits>
#include <cstdlib>
#include <errno.h>
#include <sysexits.h>
#include <cctype>
#include <cstring>
#include <cstdio>
using namespace std;

#define FOR(i, a, b) for (int i = (a); i < (b); i++)
#define REP(i, n) FOR(i, 0, n)

const int NSUB = 5, SIZE = 4;
const int N = NSUB * SIZE;
bool R[N][N], D[N][N], v[N][N], e[N][N];

void read(char *buf, int size)
{
  fgets(buf, size, stdin);
  size_t len = strlen(buf);
  while (len && isspace(buf[len-1]))
    len--;
}

int to_int(const char *s)
{
  char *end;
  errno = 0;
  long ret = strtol(s, &end, 10);
  if (errno || end == s || *end || ret < 0 || ret > INT_MAX)
    exit(EX_USAGE);
  return (int)ret;
}

void recursive_backtracking(int r, int c)
{
  int d = rand()%4, dd = rand()%2 ? 1 : 3;
  REP(i, 4) {
    int rr = r+(int[]){-1,0,1,0}[d],
        cc = c+(int[]){0,1,0,-1}[d];
    if (unsigned(rr) < N && unsigned(cc) < N && ! v[rr][cc]) {
      v[rr][cc] = true;
      if (d%2)
        R[r][c-(d==3)] = true;
      else
        D[r-(d==0)][c] = true;
      recursive_backtracking(rr, cc);
    }
    d = (d+dd)%4;
  }
}

int main()
{
  srand(time(NULL));
  char buf[4096];
  //alarm(5);
  recursive_backtracking(0, 0);
  D[N-1][N-1] = true;

  // read int
  //read(buf, sizeof buf);
  buf[0] = '5';
  buf[1] = '\0';
  int m = min(to_int(buf), NSUB*NSUB);
  vector<int> es(NSUB*NSUB);
  REP(i, NSUB*NSUB) {
    int j = rand()%(i+1);
    if (i != j)
      es[i] = es[j];
    es[j] = i;
  }
  REP(i, NSUB*NSUB) {
    if (es[i] == 0)
      swap(es[i], es[0]);
    else if (es[i] == NSUB*NSUB-1)
      swap(es[i], es[1]);
  }
  REP(i, m) {
    int x = es[i]/NSUB*SIZE, y = es[i]%NSUB*SIZE;
    FOR(r, x, x+SIZE)
      FOR(c, y, y+SIZE)
        e[r][c] = true;
  }

  // show maze
  REP(c, N) {
    putchar(e[0][c] || c && e[0][c-1] ? '.' : ' ');
    printf(e[0][c] ? c ? "_" : "@" : " ");
  }
  puts(e[0][NSUB-1] ? "." : " ");
  REP(r, N) {
    putchar(e[r][0] || e[r][1] ? '|' : ' ');
    REP(c, N) {
      putchar(e[r][c] || r+1 < N && e[r+1][c] ? D[r][c] ? ' ' : '_' : '#');
      putchar(e[r][c] || c+1 < N && e[r][c+1] ? R[r][c] ? '.' : '|' : '#');
    }
    putchar('\n');
  }
  printf("%*s$\n", 2*N-1, "");

  read(buf, sizeof buf);
  int x = to_int(buf);
}