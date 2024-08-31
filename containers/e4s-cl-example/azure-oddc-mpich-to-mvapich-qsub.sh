#!/bin/bash

./azure-setup.sh

module unload mpi
module load mpi/mvapich2-2.3.7-1

E4SCL=$(spack find --format /{hash:7} e4s-cl | head -c7)
PYTHON_HASH=$(spack dependencies -it ${E4SCL} | grep python@ | cut -d' ' -f1)
export PATH=$(spack location -i /$PYTHON_HASH)/bin:$PATH
export PYTHONPATH="$(spack load --sh ${E4SCL} | grep PYTHONPATH | cut -d';' -f1 | cut -d= -f2)"
export PATH=$(spack location -i ${E4SCL})/bin:$PATH

MPI=$(which mpirun | awk -F'/bin/mpirun' '{print $1}')

echo "Using MPI from: ${MPI}"

e4s-cl profile delete \#

e4s-cl init \
 --mpi ${MPI} \
 --profile mvapich \
 --backend singularity \
 --image `pwd`/ubuntu20.04_hypre.sif \
 --source ./source.sh

qsub azure-oddc-hypre-test-mvapich.qsub

e4s-cl profile list mvapich

