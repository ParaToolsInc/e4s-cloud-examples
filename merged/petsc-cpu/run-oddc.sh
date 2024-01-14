#!/bin/bash -e

HOSTFILE=$HOME/hosts.txt
if [[ ! -f $HOSTFILE ]] ; then
 echo error: please create MPI hostfile $HOSTFILE before running this
 exit 1
fi

mpirun -n 4 -ppn 2 --hostfile $HOSTFILE \
 ./ex50 \
  -da_grid_x 120 \
  -da_grid_y 120 \
  -pc_type lu \
  -pc_factor_mat_solver_type superlu_dist \
  -ksp_monitor \
  -ksp_view
