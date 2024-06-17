#!/bin/bash

export PETSC_DIR=$(spack location -i $(spack find -x --format '/{hash}' petsc+rocm | head))
make ex19
