#!/bin/bash -e

HOSTFILE=$HOME/hosts.txt
if [[ ! -f $HOSTFILE ]] ; then
 echo error: please create MPI hostfile $HOSTFILE before running this
 exit 1
fi

spack load quantum-espresso
mpirun -n 44 -ppn 22 --hostfile $HOSTFILE pw.x -inp pw.scf.silicon.in
