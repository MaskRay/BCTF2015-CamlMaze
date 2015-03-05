#include <algorithm>
#include <cctype>
#include <climits>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <ctime>
#include <errno.h>
#include <sysexits.h>
#include <unistd.h>
#include <vector>
using namespace std;

#define FOR(i, a, b) for (int i = (a); i < (b); i++)
#define REP(i, n) FOR(i, 0, n)

const char FLAG[] = "meowmeowmeowilikeperfectmaze";
const int NSUB = 2, SIZE = 2;
const int N = NSUB * SIZE;
bool R[N][N], D[N][N], v[N][N], e[N][N];

void read(char *buf, int size)
{
  fgets(buf, size, stdin);
  size_t len = strlen(buf);
  while (len && isspace(buf[len-1]))
    buf[--len] = '\0';
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
  v[r][c] = true;
  REP(i, 4) {
    int rr = r+(int[]){-1,0,1,0}[d],
        cc = c+(int[]){0,1,0,-1}[d];
    if (unsigned(rr) < N && unsigned(cc) < N && ! v[rr][cc]) {
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

  // generate maze
  recursive_backtracking(0, 0);
  D[N-1][N-1] = true;

  // read int
  read(buf, sizeof buf);
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
#ifdef DEBUG
  REP(c, N) {
    fputc(e[0][c] || c && e[0][c-1] ? '.' : ' ', stderr);
    fprintf(stderr, e[0][c] ? c ? "_" : "@" : " ");
  }
  fputs(e[0][N-1] ? ".\n" : " \n", stderr);
  REP(r, N) {
    fputc(e[r][0] || e[r][1] ? '|' : ' ', stderr);
    REP(c, N) {
      fputc(e[r][c] || r+1 < N && e[r+1][c] ? D[r][c] ? ' ' : '_' : '#', stderr);
      fputc(e[r][c] || c+1 < N && e[r][c+1] ? R[r][c] ? '.' : '|' : '#', stderr);
    }
    fputc('\n', stderr);
  }
  fprintf(stderr, "%*s$\n", 2*N-1, "");
  fflush(stderr);
#endif

  // send maze
  REP(r, N) {
    REP(c, N)
      putchar(R[r][c] ? '1' : '0');
    REP(c, N)
      putchar(D[r][c] ? '1' : '0');
    REP(c, N)
      putchar(e[r][c] ? '1' : '0');
  }
  fflush(stdout);

  // get path
  read(buf, sizeof buf);

  int r = -1, c = 0;
  for (char *p = buf; *p; p++) {
    int rr, cc;
    switch (*p) {
    case 'u':
      rr = r-1, cc = c;
      break;
    case 'r':
      rr = r, cc = c+1;
      break;
    case 'd':
      rr = r+1, cc = c;
      break;
    case 'l':
      rr = r, cc = c-1;
      break;
    default:
      puts("Invalid action");
      return 0;
    }
    if ((unsigned(rr) < N && unsigned(cc) < N || rr == N && cc == N-1) &&
        (rr == r ? r == -1 || R[r][min(c,cc)] : D[min(r,rr)][c]))
      r = rr, c = cc;
    else {
      puts("Hit the wall");
      return 0;
    }
  }
  if (r == N && c == N-1) {
    printf("Victory! The flag is: %s\n", FLAG);
  } else
    puts("Failed");
}
