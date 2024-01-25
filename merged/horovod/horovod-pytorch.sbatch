#!/bin/bash
#SBATCH --job-name=hvd-torch
#SBATCH --nodes=2
#SBATCH --ntasks=72
#SBATCH --ntasks-per-node=36
#SBATCH --exclusive
#SBATCH -t 0-0:05
export MV2_HOMOGENEOUS_CLUSTER=1
export MV2_SUPPRESS_JOB_STARTUP_PERFORMANCE_WARNING=1
mpiexec python3 src/pytorch_mnist.py --epochs 2 --no-cuda
