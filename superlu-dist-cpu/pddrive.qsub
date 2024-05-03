#!/bin/bash
#PBS -l nodes=2:ppn=2,walltime=2:00
#PBS -l naccesspolicy=singlejob
#PBS -N pddrive
#PBS -V

cd $PBS_O_WORKDIR

export MV2_HOMOGENEOUS_CLUSTER=1
export MV2_SUPPRESS_JOB_STARTUP_PERFORMANCE_WARNING=1
export MV2_ENABLE_AFFINITY=0

spack load superlu-dist@8: ~cuda

mpirun ./pddrive -r 2 -c 2 g20.rua
