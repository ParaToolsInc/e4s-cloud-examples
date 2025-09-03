#!/bin/bash
#SBATCH --job-name=hypre-test
#SBATCH --nodes=2
#SBATCH --ntasks=8
#SBATCH --ntasks-per-node=4
#SBATCH --exclusive
#SBATCH -t 0-0:03

. /usr/share/modules/init/bash
module purge
module load openmpi

e4s-cl --from mpich mpirun -x LD_LIBRARY_PATH -x PYTHONPATH ./hypre_test -P 2 2 2 -n 100 100 100
