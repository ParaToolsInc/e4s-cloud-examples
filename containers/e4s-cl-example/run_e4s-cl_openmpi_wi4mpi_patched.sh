#!/bin/bash

PROFILE_NAME=wi4mpi

which e4s-cl 

e4s-cl init \
	--backend singularity \
	--image /home/tutorial/ecp.simg \
	--source /home/tutorial/Zoltan/source.sh 

e4s-cl profile edit --wi4mpi /home/tutorial/wi4mpi-patch-jb/install

source bind_gdb.sh

e4s-cl --from mpich mpirun --oversubscribe -np 1 gdb ./Zoltan

e4s-cl profile delete `e4s-cl profile list -s`
