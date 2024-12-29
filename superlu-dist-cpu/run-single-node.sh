#!/bin/bash -e

spack load superlu-dist@8: ~cuda

#export MV2_ENABLE_AFFINITY=0
mpiexec -n 4 ./pddrive -r 2 -c 2 g20.rua
