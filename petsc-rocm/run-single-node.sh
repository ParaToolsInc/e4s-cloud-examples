#!/bin/bash

export PETSC_OPTIONS="-use_gpu_aware_mpi 0"

mpirun -np 2 ./ex19 \
 -snes_monitor \
 -dm_mat_type mpiaijhipsparse \
 -dm_vec_type mpihip \
 -pc_type gamg \
 -ksp_monitor \
 -mg_levels_ksp_max_it 1

