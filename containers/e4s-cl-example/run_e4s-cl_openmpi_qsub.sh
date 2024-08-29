#!/bin/bash
module purge
module load openmpi/5.0.3

#spack load e4s-cl

E4SCL=$(spack find --format /{hash:7} e4s-cl | head -c7)
PYTHON_HASH=$(spack dependencies -it ${E4SCL} | grep python@ | cut -d' ' -f1)
export PATH=$(spack location -i /$PYTHON_HASH)/bin:$PATH
export PYTHONPATH=$(spack load --sh ${E4SCL} | grep PYTHONPATH | cut -d= -f2)
export PATH=$(spack location -i ${E4SCL})/bin:$PATH
which e4s-cl

#MPI=$(which mpirun | awk -F'/bin/mpirun' '{print $1}')
MPI=$(which mpirun)
echo "Using MPI from: ${MPI}"
return 0
e4s-cl profile delete \#

e4s-cl init --mpi ${MPI} --launcher_args "-x LD_LIBRARY_PATH=$LD_LIBRARY_PATH" --profile ompi  --backend singularity --image `pwd`/ubuntu20.04_hypre.sif --source ./source.sh

qsub hypre_test_openmpi.qsub

e4s-cl profile list ompi
