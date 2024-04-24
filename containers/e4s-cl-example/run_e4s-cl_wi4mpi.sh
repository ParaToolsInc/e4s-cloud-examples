#!/bin/bash

PROFILE_NAME=wi4mpi

which e4s-cl 
module load wi4mpi

e4s-cl init --profile $PROFILE_NAME \
	--backend singularity \
	--image /home/tutorial/ecp.simg \
	--source /home/tutorial/source.sh \
	--wi4mpi $WI4MPI_ROOT \
	--wi4mpi_options "-F mpich -T openmpi"

which mpirun
e4s-cl profile list

e4s-cl mpirun -np 4 ./Zoltan

e4s-cl profile delete $PROFILE_NAME
