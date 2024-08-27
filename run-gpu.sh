#!/bin/bash
#SBATCH --job-name=RBGaussSeidel
#SBATCH --output=out/GPU-%x-%j.out
#SBATCH --time=00:10:00
#SBATCH --partition=gpu1
#SBATCH --exclusive
#SBATCH --hint=compute_bound
#SBATCH --nodes=1
#SBATCH --cpus-per-task=24

. /vol0004/apps/oss/spack/share/spack/setup-env.sh
spack load gcc@13.2.0%gcc@8.5.0 arch=linux-rhel8-skylake_avx512

export OMP_NUM_THREADS=24

./$1

rm $1