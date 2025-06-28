#!/bin/bash -e

HASH=$(spack find --format /{hash} superlu-dist@8: ~cuda | head -1)
SUPERLU_DIST_ROOT=$(spack location -i $HASH)

mpicc \
 -I${SUPERLU_DIST_ROOT}/include \
 -L${SUPERLU_DIST_ROOT}/lib \
 -o pddrive \
 pddrive.c dcreate_matrix.c -lsuperlu_dist
