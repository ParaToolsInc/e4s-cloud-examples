#!/bin/bash -e

HOSTFILE=$HOME/hosts.txt
if [[ ! -f $HOSTFILE ]] ; then
 echo error: please create MPI hostfile $HOSTFILE before running this
 exit 1
fi
 
spack load superlu-dist@8: ~cuda
export MV2_ENABLE_AFFINITY=0
mpiexec -n 4 -ppn 2 --hostfile $HOSTFILE \
  ./pddrive -r 2 -c 2 g20.rua
