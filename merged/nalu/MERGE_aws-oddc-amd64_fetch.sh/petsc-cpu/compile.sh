#!/bin/bash -e

export PETSC_DIR=$(spack location -i $(spack find -x --format '/{hash}' petsc@3.19:~cuda | head))
make ex50
