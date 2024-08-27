#include <omp.h>

#include <iostream>

int main() {

  printf("#pragma omp parallel for schedule(dynamic, 2)\n");
#pragma omp parallel for schedule(dynamic, 2)
  for (int j = 1; j < 10; j++) {
  }

  printf("\n");
  printf("#pragma omp parallel for schedule(dynamic, auto)\n");
#pragma omp parallel for schedule(dynamic, auto)
  for (int j = 1; j < 10; j++) {
  }

  printf("\n");
  printf("#pragma omp parallel\n");
  printf("#pragma omp for schedule(dynamic, 2)\n");
#pragma omp parallel
  {
#pragma omp for schedule(dynamic, 2)
    for (int j = 1; j < 10; j++) {
    }
  }

  printf("\n");
  printf("#pragma omp parallel\n");
  printf("#pragma omp for schedule(dynamic, auto)\n");
#pragma omp parallel
  {
#pragma omp for schedule(dynamic, auto)
    for (int j = 1; j < 10; j++) {
    }
  }

  printf("\n");
  printf("#pragma omp parallel\n");
  printf("#pragma omp for schedule(guided, auto)\n");
#pragma omp parallel
  {
#pragma omp for schedule(guided, auto)
    for (int j = 1; j < 10; j++) {
    }
  }

  printf("\n");
  printf("#pragma omp parallel for schedule(static, 2)\n");
#pragma omp parallel for schedule(static, 2)
  for (int j = 1; j < 10; j++) {
  }

  printf("\n");
  printf("#pragma omp parallel for schedule(static, auto)\n");
#pragma omp parallel for schedule(static, auto)
  for (int j = 1; j < 10; j++) {
  }

  return 0;
}