#!/bin/bash
#SBATCH --job-name=lammps
#SBATCH --nodes=2
#SBATCH --ntasks=32
#SBATCH --ntasks-per-node=16
#SBATCH -t 0-0:10
#SBATCH --exclusive
export MV2_HOMOGENEOUS_CLUSTER=1
export MV2_SUPPRESS_JOB_STARTUP_PERFORMANCE_WARNING=1
spack load --first lammps
export OMP_NUM_THREADS=2
mpiexec  lmp -in ./in.lj



