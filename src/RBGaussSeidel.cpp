#include <omp.h>

#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>

#ifndef N
#define N 2001
#endif
#ifndef S
#define S 1000
#endif
#ifndef SCHED
#define SCHED dynamic, auto
#endif

#define MAX_ITER S

int PARAM_AMOUNT;

double thread_time[200];

void initialize(double **A, int n) {
  int i, j;
  for (j = 0; j < n + 1; j++) {
    A[0][j] = 1.0;
  }
  for (i = 1; i < n + 1; i++) {
    A[i][0] = 1.0;
    for (j = 1; j < n + 1; j++) {
      A[i][j] = 1.0;
    }
  }
}

double matrix_calculation(double **A, int n) {
  double tmp;
  double diff = 0;
  int i, j;

#ifdef _OPENMP
#pragma omp parallel private(tmp, i, j)
#endif
  {
    double start = omp_get_wtime();
#ifdef _OPENMP
#pragma omp for reduction(+ : diff) schedule(SCHED) collapse(2)
#endif
    for (i = 1; i <= n; ++i) {
      for (j = 1; j <= n; ++j) {
        if ((i + j) % 2 == 1) {
          tmp = A[i][j];
          A[i][j] = 0.2 * (A[i][j] + A[i][j - 1] + A[i - 1][j] + A[i][j + 1] +
                           A[i + 1][j]);
          diff += fabs(A[i][j] - tmp);
        }
      }
    }
#ifdef _OPENMP
#pragma omp for reduction(+ : diff) schedule(SCHED) collapse(2)
#endif
    for (i = 1; i <= n; ++i) {
      for (j = 1; j <= n; ++j) {
        if ((i + j) % 2 == 0) {
          tmp = A[i][j];
          A[i][j] = 0.2 * (A[i][j] + A[i][j - 1] + A[i - 1][j] + A[i][j + 1] +
                           A[i + 1][j]);
          diff += fabs(A[i][j] - tmp);
        }
      }
    }
    thread_time[omp_get_thread_num()] += omp_get_wtime() - start;
  }
  return diff;
}

void solve_parallel(double **A, int n) {
  int iters;
  double diff;

  // printf("\n\n-----------------------Parallel Red Black "
  //        "Solver-----------------------\n\n\n");

  for (iters = 1; iters < MAX_ITER; ++iters) {
    diff = matrix_calculation(A, N - 1);
  }

  // printf("Difference after %3d iterations: %f\n", iters, diff);
  // printf("\n\nIteration LIMIT Reached...Exiting\n\n");
}

int main(int argc, char *argv[]) {

  std::memset(thread_time, 0, sizeof(thread_time));

  PARAM_AMOUNT = 1;
  if (argc > 1) {
    PARAM_AMOUNT = atoi(argv[1]);
  }

  int i;
  double t_start, t_end;
  double **A;
  A = new double *[N + 2];
  for (i = 0; i < N + 2; ++i) {
    A[i] = new double[N + 2];
  }

  initialize(A, N);

  t_start = omp_get_wtime();
  solve_parallel(A, N - 1);
  t_end = omp_get_wtime();

  printf("Computation time on %i threads: %f\n\n", omp_get_max_threads(),
         t_end - t_start);

  // for (i = 0; i < omp_get_max_threads(); ++i) {
  //   printf("Thread %d: %f\n", i, thread_time[i]);
  // }
}