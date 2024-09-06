#include <omp.h>
#include <stdio.h>

int main() {

  for (int i = 0; i < 3; ++i) {

    printf("%i Dynamic \n", i);
#pragma omp parallel for schedule(dynamic, auto)
    for (long long j = 1; j < 200; ++j) {
    }

#pragma omp parallel for schedule(dynamic, auto) collapse(2)
    for (int j = 1; j < 200; ++j) {
      for (int k = 0; k < 10; ++k) {
      }
    }

// #pragma omp parallel for schedule(dynamic, auto)
//     for (unsigned long long j = 1; j < 200; ++j) {
//     }

//     printf("%i Static \n", i);
// #pragma omp parallel for schedule(static, auto)
//     for (int j = 1; j < 10; ++j) {
//     }

//     printf("%i Guided \n", i);
// #pragma omp parallel for schedule(guided, auto)
//     for (short j = 1; j < 10; ++j) {
    // }
  }

  return 0;
}