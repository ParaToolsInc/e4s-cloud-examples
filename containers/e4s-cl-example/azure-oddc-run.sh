#!/bin/bash

# First check if ubuntu20.04-hypre.sh container exists
if [ ! -r  ../e4s-alc-example/ubuntu20.04_hypre.sif ]; then
	echo "Building ubuntu20.04_hypre.sif using e4s-alc"
	cd ../e4s-alc-example; ./run.sh; cd -
fi
if [ ! -r ./hypre_test ]; then
  echo "Building hypre_test using the container"
  if [ -d /.singularity.d ]; then
    ./compile.sh
  else 
    singularity exec ubuntu20.04_hypre.sif ./compile.sh
  fi 
fi

if [ -d /.singularity.d ]; then
  echo "Running inside the container"
  make 
  make run
else
  echo "Running with e4s-cl and mvapich"
  ./azure-oddc-mpich-to-mvapich.sh
  echo "Running with e4s-cl and openmpi"
  ./azure-oddc-mpich-to-openmpi.sh
fi
