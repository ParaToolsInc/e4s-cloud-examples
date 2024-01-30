#!/bin/bash
#SBATCH --job-name=xyce
#SBATCH --nodes=2
#SBATCH --ntasks=4
#SBATCH --ntasks-per-node=2
#SBATCH -t 0-0:10
#SBATCH --exclusive
export MV2_HOMOGENEOUS_CLUSTER=1
export MV2_SUPPRESS_JOB_STARTUP_PERFORMANCE_WARNING=1
spack load --first xyce
mpiexec Xyce ./rc_simple_xyce.cir
