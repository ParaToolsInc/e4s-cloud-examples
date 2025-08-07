#!/bin/bash -e

HASH=$(spack find -x --format '/{hash}' petsc@3.19:~cuda | head -1)
PETSC_ROOT=$(spack location -i $HASH)
export PETSC_DIR=$PETSC_ROOT
make ex50
