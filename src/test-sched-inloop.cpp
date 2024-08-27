#include <omp.h>

#include <iostream>

int main() {

  printf("\n");
  printf("#pragma omp parallel for schedule(dynamic, auto)\n");

  bool reset = false;

  for (int i = 0; i < 100; i++) {
#pragma omp parallel for schedule(dynamic, auto) autoreset(reset)
    for (int j = 1; j < 1000; j++) {
    }
  }

  return 0;
}