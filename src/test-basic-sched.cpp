#include <omp.h>

#include <iostream>

int main() {

#pragma omp parallel for schedule(dynamic)
  for (int j = 1; j < 10; j++) {
  }

  return 0;
}