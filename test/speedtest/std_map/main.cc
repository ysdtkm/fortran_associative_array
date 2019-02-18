#include <bits/stdc++.h>

const int jmax = 20;

using namespace std;

int main() {
    int i, j, n, a[1 << jmax];
    for (j = 5; j <= jmax; j++) {
        map <int, float> mp;

        n = 1 << j;
        srand(0);
        for (i = 0; i < n; i++) {
            a[i] = rand() % n;
        }

        auto t1 = chrono::high_resolution_clock::now();
        for (i = 0; i < n; i++) {
            mp.insert_or_assign(a[i], (float) a[i]);
        }
        auto t2 = chrono::high_resolution_clock::now();
        auto dt = (t2 - t1).count();  // nanosec
        cout << n << " " << ((double) dt) / (n * 1.0e9) << endl;
    }
    return 0;
}
