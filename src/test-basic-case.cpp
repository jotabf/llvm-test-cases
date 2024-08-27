#include <omp.h>

int main() {
  int a = 0;
  #pragma omp parallel
  {
    a = 1;
  }

  return a;
}