#!/bin/bash
module load tau
mpirun -np 4 tau_exec -ebs ./CoMD-mpi --xproc 4 --yproc 1 --zproc 1 --nx 80 --ny 40 --nz 40



