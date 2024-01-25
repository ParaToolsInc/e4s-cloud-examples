#!/bin/bash
#SBATCH --job-name=qe
#SBATCH --nodes=2
#SBATCH --ntasks=44
#SBATCH --ntasks-per-node=22
#SBATCH -t 0-0:20
#SBATCH --exclusive
export MV2_HOMOGENEOUS_CLUSTER=1
export MV2_SUPPRESS_JOB_STARTUP_PERFORMANCE_WARNING=1
spack load quantum-espresso
mpiexec pw.x -inp pw.scf.silicon.in
