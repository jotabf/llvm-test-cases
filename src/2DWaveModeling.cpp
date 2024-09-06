#include <cmath>
#include <iostream>
#include <omp.h>
#include <unistd.h>
#include <algorithm>

#ifndef SCHED
#define SCHED dynamic, auto
#endif
#ifndef N
#define N 1000
#endif
#ifndef S
#define S 2000
#endif
#ifndef B
#define B 10
#endif

const int boundary = 0;     // Absorbent boundary size
const int gridsize = N;     // Grid size
const int samples = S;      // Number of time steps
const double c = 1.0;       // Wave speed
const double dt = 0.01;     // Time step
const double dx = 1.0;      // Grid spacing
const double lambda = 0.02; // Absorption factor

// Initialize grid and time steps
double **u, **u_prev, **u_next;

void print_grid();

void initialize() {
  u = new double *[gridsize];
  u_prev = new double *[gridsize];
  u_next = new double *[gridsize];

  for (int i = 0; i < gridsize; ++i) {
    u[i] = new double[gridsize];
    u_prev[i] = new double[gridsize];
    u_next[i] = new double[gridsize];

    std::fill(u[i], u[i] + gridsize, 0.0);
    std::fill(u_prev[i], u_prev[i] + gridsize, 0.0);
    std::fill(u_next[i], u_next[i] + gridsize, 0.0);
  }
  // Initial conditions: a pulse in the center
  int cx = gridsize / 2, cy = gridsize / 2;
  u[cx][cy] = 1.0;
}

void update_wave() {
  double coeff = (c * dt / dx) * (c * dt / dx);

  for (int n = 0; n < samples; ++n) {

#pragma omp parallel for collapse(2) schedule(SCHED)
    for (int i = 1; i < gridsize - 1; ++i) {
      for (int j = 1; j < gridsize - 1; ++j) {
        u_next[i][j] = 2 * u[i][j] - u_prev[i][j] +
                       coeff * (u[i + 1][j] + u[i - 1][j] + u[i][j + 1] +
                                u[i][j - 1] - 4 * u[i][j]);

        // Apply boundary conditions
        if (i < boundary || i >= gridsize - boundary || j < boundary ||
            j >= gridsize - boundary)
          u_next[i][j] *= (1 - lambda);
      }
    }

    // // Apply absorbent boundary conditions
    // #pragma omp parallel for
    //     for (int i = 0; i < gridsize; ++i) {
    //       u_next[i][0] *= (1 - lambda);
    //       u_next[i][gridsize - 1] *= (1 - lambda);
    //       u_next[0][i] *= (1 - lambda);
    //       u_next[gridsize - 1][i] *= (1 - lambda);
    //     }

    // Update time steps
    u_prev = u;
    u = u_next;
  }
}

void print_grid() {
  for (int i = 0; i < gridsize; ++i) {
    for (int j = 0; j < gridsize; ++j) {
      std::cout << (u[i][j] > 0.01 ? "*" : " ") << " ";
    }
    std::cout << std::endl;
  }
}

int main() {
  initialize();

  double start = omp_get_wtime();
  update_wave();
  double end = omp_get_wtime();

  std::cout << "Elapsed time: " << end - start << " s" << std::endl;
  return 0;
}
