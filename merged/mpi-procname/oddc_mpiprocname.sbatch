#!/bin/bash
#SBATCH --job-name=mpiprocname
#SBATCH --nodes=2
#SBATCH --ntasks=4
#SBATCH --ntasks-per-node=2
#SBATCH -t 0-0:02
export MV2_HOMOGENEOUS_CLUSTER=1
export MV2_SUPPRESS_JOB_STARTUP_PERFORMANCE_WARNING=1
srun --mpi=pmi2 ./mpiprocname
