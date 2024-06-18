#!/bin/bash -e

mpiexec -n 4 \
 ./bench_kspsolve \
  -n 128 \
  -its 1000 \
  -matmult \
  -mat_type aijcusparse \
  -use_gpu_aware_mpi 0
