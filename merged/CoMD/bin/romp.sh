#!/bin/bash
spack load tau
export OMP_NUM_THREADS=4
mpirun -np 4 tau_exec -ebs ./CoMD-openmp-mpi --xproc 4 --yproc 1 --zproc 1 --nx 80 --ny 40 --nz 40



