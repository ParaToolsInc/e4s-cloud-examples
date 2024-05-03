#!/bin/bash
module load openmpi

spack load e4s-cl
MPI=$(which mpirun | awk -F'/bin/mpirun' '{print $1}')

echo "Using MPI from: ${MPI}"

e4s-cl init --mpi ${MPI} --profile ompi  --backend singularity --image `pwd`/ubuntu20.04_hypre.sif --source ./source.sh

e4s-cl --from mpich mpirun -np 8 ./hypre_test -P 2 2 2 -n 100 100 100 

e4s-cl profile list ompi

e4s-cl profile delete ompi
