#include <omp.h>
#include <stdio.h>

int main() {

  int a = 0;
#pragma omp parallel 
  { a++; }

  printf("a = %d\n", a);

  return 0;
}