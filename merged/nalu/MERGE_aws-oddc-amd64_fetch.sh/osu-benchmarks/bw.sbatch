#!/bin/bash
#SBATCH --job-name=osu-bw
#SBATCH --output=osu-bw.log
#SBATCH --nodes=2
#SBATCH --ntasks=2
#SBATCH --ntasks-per-node=1
#SBATCH -t 0-0:05
export MV2_HOMOGENEOUS_CLUSTER=1
export MV2_SUPPRESS_JOB_STARTUP_PERFORMANCE_WARNING=1
srun --pmi=pmi2 osu_bw
