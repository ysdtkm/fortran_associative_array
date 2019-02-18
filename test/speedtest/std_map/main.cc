#include <bits/stdc++.h>

const int jmax = 22;
int a[1 << jmax];

using namespace std;

int main() {
    int i, j, n, itr, itrmax;
    for (j = 5; j <= jmax; j++) {
        itrmax = 1 << (jmax - j);
        double dt = 0.0;
        for (itr = 0; itr < itrmax; itr++) {
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
            dt += (double) (t2 - t1).count();  // nanosec
        }
        cout << n << " " << dt / (n * 1.0e9 * itr) << endl;
    }
    return 0;
}
