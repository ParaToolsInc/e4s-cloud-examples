#!/bin/bash
#SBATCH --job-name=TeaLeaf        # Job name
#SBATCH --partition=develbooster  # Job partition
#SBATCH --nodes=2                 # Total number of nodes requested
#SBATCH --gres=gpu:4              # Number of GPUs per node
#SBATCH --ntasks-per-node=4       # Number of MPI tasks per node (one per GPU)
#SBATCH --time=00:05:00           # Max. wall-clock time (hh:mm:ss)
#SBATCH --account=training2123    # Project account to be charged
#SBATCH --output=%x.%j.out        # Output files
#SBATCH --error=%x.%j.out


srun ./tea_leaf
