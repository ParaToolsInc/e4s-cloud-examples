#!/bin/bash -e

HOSTFILE=$HOME/hosts.txt
if [[ ! -f $HOSTFILE ]] ; then
 echo error: please create MPI hostfile $HOSTFILE before running this
 exit 1
fi

spack load xyce
mpirun -n 4 -ppn 2 --hostfile $HOSTFILE Xyce ./CD40P_Temp1.cir
