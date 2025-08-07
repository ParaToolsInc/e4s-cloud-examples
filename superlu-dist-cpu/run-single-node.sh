#!/bin/bash -e

HASH=$(spack find --format /{hash} superlu-dist@8: ~cuda | head -1)
SUPERLU_DIST_ROOT=$(spack location -i $HASH)
spack load $HASH
export LD_LIBRARY_PATH=$SUPERLU_DIST_ROOT/lib:$LD_LIBRARY_PATH

mpirun -n 4 ./pddrive -r 2 -c 2 g20.rua
