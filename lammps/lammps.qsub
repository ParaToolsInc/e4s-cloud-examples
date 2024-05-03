#!/bin/bash
#PBS -l nodes=2:ppn=16,walltime=10:00
#PBS -l naccesspolicy=singlejob
#PBS -N lammps
#PBS -V

cd $PBS_O_WORKDIR

export MV2_HOMOGENEOUS_CLUSTER=1
export MV2_SUPPRESS_JOB_STARTUP_PERFORMANCE_WARNING=1
export MV2_ENABLE_AFFINITY=0

export OMP_NUM_THREADS=2

spack load --first lammps
mpiexec  lmp -in ./in.lj
