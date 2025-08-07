#!/bin/bash
#SBATCH --job-name=pddrive
#SBATCH --nodes=2
#SBATCH --ntasks=4
#SBATCH --ntasks-per-node=2
#SBATCH --exclusive
#SBATCH -t 0-0:02

HASH=$(spack find --format /{hash} superlu-dist@8: ~cuda | head -1)
SUPERLU_ROOT=$(spack location -i $HASH)
export LD_LIBRARY_PATH=$SUPERLU_ROOT/lib:$LD_LIBRARY_PATH
spack load $HASH

mpirun ./pddrive -r 2 -c 2 g20.rua
