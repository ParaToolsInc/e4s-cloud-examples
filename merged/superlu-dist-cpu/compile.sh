#!/bin/bash -e

SUPERLU_DIST_ROOT=$(spack location -i $(spack find --format /{hash} superlu-dist@8: ~cuda | head -1))

mpicc \
 -I${SUPERLU_DIST_ROOT}/include \
 -L${SUPERLU_DIST_ROOT}/lib \
 -o pddrive \
 pddrive.c dcreate_matrix.c -lsuperlu_dist
