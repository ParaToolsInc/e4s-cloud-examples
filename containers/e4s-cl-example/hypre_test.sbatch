#!/bin/bash
#SBATCH --job-name=hyper-test
#SBATCH --nodes=2
#SBATCH --ntasks=8
#SBATCH --ntasks-per-node=4
#SBATCH --exclusive
#SBATCH -t 0-0:02
export MV2_HOMOGENEOUS_CLUSTER=1
export MV2_SUPPRESS_JOB_STARTUP_PERFORMANCE_WARNING=1
e4s-cl mpirun ./hypre_test -P 2 2 2 -n 100 100 100
