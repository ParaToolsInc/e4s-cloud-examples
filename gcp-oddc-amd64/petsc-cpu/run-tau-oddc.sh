#!/bin/bash -e

HOSTFILE=$HOME/hosts.txt
if [[ ! -f $HOSTFILE ]] ; then
 echo error: please create MPI hostfile $HOSTFILE before running this
 exit 1
fi

/bin/rm -rf MULT* profile* 
# Use TAU's perfstubs API 
mpirun -n 4 -ppn 2 --hostfile $HOSTFILE \
 tau_exec -ebs \
 ./ex50 \
  -da_grid_x 1024 \
  -da_grid_y 1024 \
  -pc_type lu \
  -pc_factor_mat_solver_type superlu_dist \
  -ksp_monitor \
  -ksp_view \
  -log_perfstubs
