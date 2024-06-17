#!/bin/bash

export PETSC_DIR=$(spack location -i $(spack find -x --format '/{hash}' petsc+cuda | head))
make ex19
