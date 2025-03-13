#!/bin/bash
#SBATCH --job-name=inf2-matmult
#SBATCH --output=inf2-matmult.log
#SBATCH --partition=inf2
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --exclusive
#SBATCH -t 0-0:30

source /opt/aws_neuron_venv_pytorch/bin/activate

python inf2-matmult.py 


