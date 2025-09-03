#!/bin/bash
#SBATCH --job-name=hypre-test
#SBATCH --nodes=2
#SBATCH --ntasks=8
#SBATCH --ntasks-per-node=4
#SBATCH --exclusive
#SBATCH -t 0-0:03

module purge
module load mvapich

e4s-cl mpirun ./hypre_test -P 2 2 2 -n 100 100 100
