#!/bin/bash -e

PREFILE=$HOME/.hosts-w-slots.txt.pre
HOSTFILE=$HOME/hosts-w-slots.txt
if [[ ! -f $HOSTFILE ]] ; then
  cat /etc/hosts | awk '{ print $1;}' | tail -2  > $PREFILE
  for l in $(cat $PREFILE) ; do
   echo $l slots=36 >> $HOSTFILE
  done
  rm -f $PREFILE
fi

horovodrun -np 72 -hostfile $HOSTFILE python3 src/pytorch_mnist.py --epochs 2 --no-cuda
