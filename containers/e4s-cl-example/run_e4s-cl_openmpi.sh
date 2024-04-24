#!/bin/bash

PROFILE_NAME=wi4mpi

which e4s-cl 

e4s-cl init \
	--backend singularity \
	--image /home/tutorial/ecp.simg \
	--source /home/tutorial/Zoltan/source.sh 

which mpirun
e4s-cl profile list

e4s-cl --from mpich mpirun --oversubscribe -np 4 ./Zoltan

e4s-cl profile delete `e4s-cl profile list -s`
