#include <omp.h>

#include <iostream>

int main() {

  printf("\n");
  printf("#pragma omp parallel for schedule(dynamic, auto)\n");

  bool reset = false;

  for (int i = 0; i < 100; i++) {

#pragma omp parallel for schedule(dynamic, auto) // autoreset(reset)
    for (int j = 0; j < i; j++) {
    }


  }

  return 0;
}