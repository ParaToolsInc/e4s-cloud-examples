#!/bin/bash -e

cat /etc/hosts | awk '{ print $1;}' | tail -2  > ~/hosts.txt
HOSTFILE=$HOME/hosts.txt
if [[ ! -f $HOSTFILE ]] ; then
 echo error: please create MPI hostfile $HOSTFILE before running this
 exit 1
fi

mpirun -n 2 -ppn 1 --hostfile $HOSTFILE ./mpiprocname 
