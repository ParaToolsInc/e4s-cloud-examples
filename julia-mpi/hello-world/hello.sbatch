#!/bin/bash
#SBATCH --job-name=hellojulia
#SBATCH --nodes=2
#SBATCH --ntasks=4
#SBATCH --ntasks-per-node=2
#SBATCH --exclusive
#SBATCH -t 0-0:09

mpiexec julia ./hello-world.jl
