#include <omp.h>
#include <stdio.h>

int main() {

#pragma omp parallel for schedule(dynamic, auto)
  for (int j = 1; j < 10; ++j) {
  }

  return 0;
}