#!/bin/bash
#SBATCH --job-name=bench_kspsolve
#SBATCH --nodes=2
#SBATCH --ntasks=4
#SBATCH --ntasks-per-node=2
#SBATCH --exclusive
#SBATCH -t 0-0:02


mpiexec ./bench_kspsolve \
  -n 128 \
  -its 1000 \
  -matmult \
  -mat_type aijcusparse \
  -use_gpu_aware_mpi 0

