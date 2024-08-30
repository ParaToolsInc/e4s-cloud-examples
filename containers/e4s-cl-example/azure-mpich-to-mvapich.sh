#!/bin/bash
#module load mvapich2-x-aws
# Uncomment and use the correct mvapich2 module name.

spack load e4s-cl
module unload mpi
module load mpi/mvapich2

MPI=$(which mpirun | awk -F'/bin/mpirun' '{print $1}')

echo "Using MPI from: ${MPI}"

e4s-cl init --mpi ${MPI} --profile mvapich --backend singularity --image `pwd`/ubuntu20.04_hypre.sif --source ./source.sh

e4s-cl mpirun -np 8 ./hypre_test -P 2 2 2 -n 100 100 100 

e4s-cl profile list mvapich
