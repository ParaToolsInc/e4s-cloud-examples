#!/bin/bash
#SBATCH --job-name=ex19
#SBATCH --nodes=2
#SBATCH --ntasks=2
#SBATCH --ntasks-per-node=1
#SBATCH --exclusive
#SBATCH -t 0-0:02

export MV2_HOMOGENEOUS_CLUSTER=1
export MV2_SUPPRESS_JOB_STARTUP_PERFORMANCE_WARNING=1

mpiexec ./ex19 \
 -snes_monitor \
 -dm_mat_type mpiaijhipsparse \
 -dm_vec_type mpihip \
 -pc_type gamg \
 -ksp_monitor \
 -mg_levels_ksp_max_it 1

