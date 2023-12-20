#!/bin/bash -e

HOSTFILE=$HOME/hosts.txt
if [[ ! -f $HOSTFILE ]] ; then
 echo error: please create MPI hostfile $HOSTFILE before running this
 exit 1
fi

spack load lammps
export OMP_NUM_THREADS=2
mpirun -n 32 -ppn 16 --hostfile $HOSTFILE lmp -in ./in.lj
