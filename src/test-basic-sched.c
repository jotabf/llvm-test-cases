#include <omp.h>
#include <stdio.h>

int main() {

  for (int i = 0; i < 3; ++i) {

    printf("%i First \n", i);
#pragma omp parallel for schedule(dynamic, auto)
    for (int j = 1; j < 200; ++j) {
    }

    printf("%i Second \n", i);
#pragma omp parallel for schedule(dynamic, auto)
    for (int j = 1; j < 10; ++j) {
    }
  }

  return 0;
}