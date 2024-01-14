#!/bin/bash -e

HOSTFILE=$HOME/hosts.txt
if [[ ! -f $HOSTFILE ]] ; then
 echo error: please create MPI hostfile $HOSTFILE before running this
 exit 1
fi

mpirun -n 2 -ppn 1 --hostfile $HOSTFILE osu_latency
