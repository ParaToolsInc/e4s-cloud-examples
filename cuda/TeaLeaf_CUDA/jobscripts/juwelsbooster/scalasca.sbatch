#!/bin/bash
#SBATCH --job-name=TeaLeaf_scalasca  # Job name
#SBATCH --partition=develbooster     # Job partition
#SBATCH --nodes=2                    # Total number of nodes requested
#SBATCH --gres=gpu:4                 # Number of GPUs per node
#SBATCH --ntasks-per-node=4          # Number of MPI tasks per node (one per GPU)
#SBATCH --time=00:05:00              # Max. wall-clock time (hh:mm:ss)
#SBATCH --account=training2123       # Project account to be charged
#SBATCH --output=%x.%j.out           # Output files
#SBATCH --error=%x.%j.out

# Score-P measurement configuration
export SCOREP_CUDA_ENABLE=default
export SCOREP_CUDA_BUFFER=48M

#export SCOREP_EXPERIMENT_DIRECTORY=scorep-tea_leaf-8
#export SCOREP_FILTERING_FILE=../config/scorep.filter

#export SCOREP_ENABLE_TRACING=true
#export SCOREP_TOTAL_MEMORY=120M


# Scalasca configuration
export SCAN_ANALYZE_OPTS="--time-correct"


# Run the application
scan -s  srun ./tea_leaf
