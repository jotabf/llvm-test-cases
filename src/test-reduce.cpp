#include <stdio.h>
#include <omp.h>

int main() {
    int i;
    const int N = 1000;
    int arr[N];
    int sum = 0;

    // Initialize array with values 1 to N
    for (i = 0; i < N; i++) {
        arr[i] = i + 1;
    }

    // Parallel region with reduction on sum
    #pragma omp parallel for reduction(+:sum)
    for (i = 0; i < N; i++) {
        sum += arr[i];  // Each thread computes a partial sum
    }

    printf("Sum of array elements: %d\n", sum);

    int last_value = 0;

    // Parallel region with lastprivate clause
    #pragma omp parallel for lastprivate(last_value)
    for (i = 0; i < N; i++) {
        last_value = i;  // Each thread will update its own private copy of last_value
        printf("Thread %d: i = %d, last_value = %d\n", omp_get_thread_num(), i, last_value);
    }

    // After the parallel loop, last_value will be equal to the last iteration value
    printf("After parallel loop, last_value = %d\n", last_value);
    return 0;
}
