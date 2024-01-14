# Merging Notes: 

## mpi-procname/

### run-oddc.sh to aws_run-oddc.sh and gcp_run-oddc.sh
The diff is:

    3c3,7
    < cat /etc/hosts | awk '{ print $1;}' | tail -2  > ~/hosts.txt
    ---
    > # Pick the last two hosts in the /etc/hosts file and put these in ~/hosts.txt
    > #cat /etc/hosts | awk '{ print $1;}' | tail -2  > ~/hosts.txt
    > # Pick the hosts that start with nodus-<name> in ~/hosts.txt 
    > cat /etc/hosts | grep nodus- | awk '{print $1;}' > ~/hosts.txt

I assume one of those is strictly correct on all oddc systems but I don't know which.

### mpiprocname.sbatch to oddc_mpiprocname.sbatch  pcluster_mpiprocname.sbatch

    The diff is:
    9c9
    < srun --mpi=pmi2 ./mpiprocname
    ---
    > mpiexec ./mpiprocname

I need to find environment variables or other means of identifying oddc vs pcluster. These could be used to unify these scripts.


## petsc-cpu/

### ex50.sbatch to oddc_ex50.sbatch  pcluster_ex50.sbatch

Same as mpi-procname sbatch


## osu-benchmarks/

### bw.sbatch, latency.sbatch, bibw.sbatch

Same as mpi-procname sbatch

## tau/

### demo.ppk to -> aws-oddc-amd64_demo.ppk  gcp-oddc-amd64_demo.ppk

These have different hashes. My guess is one can be deleted.

## TODO

Tests not previously included with every platform need to be validated on all platforms. Directories need to be organized so tests (currently) not functional on all platforms are identified. Eventually all tests should be modified to function on all platforms.

### All platforms:
mpi-procname, nalu, osu-benchmarks, petsc-cpu, superlu-dist-cpu and visit. tau is absent from the pcluster directories but it only contains a ppk file so I assume it is valid everywhere. 

### pcluster only:
CoMD, demo, julia-mpi, machine-learning, matmult

### oddc only: 
xyce

### gpc-oddc only: 
jupyter-notebook, lammps, openfoam, pytorch, qe, tensorflow
