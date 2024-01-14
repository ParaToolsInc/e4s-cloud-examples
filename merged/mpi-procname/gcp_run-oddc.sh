#!/bin/bash -e

# Pick the last two hosts in the /etc/hosts file and put these in ~/hosts.txt
#cat /etc/hosts | awk '{ print $1;}' | tail -2  > ~/hosts.txt
# Pick the hosts that start with nodus-<name> in ~/hosts.txt 
cat /etc/hosts | grep nodus- | awk '{print $1;}' > ~/hosts.txt

HOSTFILE=$HOME/hosts.txt
if [[ ! -f $HOSTFILE ]] ; then
 echo error: please create MPI hostfile $HOSTFILE before running this
 exit 1
fi

mpirun -n 2 -ppn 1 --hostfile $HOSTFILE ./mpiprocname 
