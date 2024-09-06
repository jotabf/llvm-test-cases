#include <stdio.h>
#include <omp.h>

int main() {
    const int N = 16;
    int data[N];

    // Initialize the array
    for (int i = 0; i < N; i++) {
        data[i] = i;
    }

    // Offloading work to multiple teams (e.g., GPU)
    #pragma omp target teams distribute parallel for schedule(static)
    for (int i = 0; i < N; i++) {
        data[i] *= 2;  // Each element of the array is multiplied by 2
    }

    // Print the modified array
    for (int i = 0; i < N; i++) {
        printf("data[%d] = %d\n", i, data[i]);
    }

    return 0;
}
