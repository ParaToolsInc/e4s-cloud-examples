#!/bin/bash
# ln -s /lib/x86_64-linux-gnu/libibverbs.so{.1,}
spack load e4s-cl

module load mvapich2-x-aws

MPI=$(which mpirun | awk -F'/bin/mpirun' '{print $1}')

echo "Using MPI from: ${MPI}"

e4s-cl init --mpi ${MPI} --profile mvapich --backend singularity --image `pwd`/ubuntu20.04_hypre.sif --source ./source.sh

e4s-cl mpirun -np 8 ./hypre_test -P 2 2 2 -n 100 100 100 

e4s-cl profile list mvapich
