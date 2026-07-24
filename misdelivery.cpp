#include <bits/stdc++.h>
using namespace std;

int main() {
  int n;
  cin >> n;
  vector<int> rooms(n);
  for (int i = 0; i < n; i++) {
    cin >> rooms[i];
  }

  int x, y;
  cin >> x >> y;
  
  string sol = (rooms[y+1] == y) ? "Yes" : "No";
  cout << sol << endl;
} 
