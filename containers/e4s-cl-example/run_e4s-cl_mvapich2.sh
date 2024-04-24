#!/bin/bash
which e4s-cl 
#. /opt/intel/oneapi/setvars.sh
# To use MVAPICH2 MPI, please comment the Intel line above and uncomment the one below:
module load mvapich2
e4s-cl init --backend singularity --image /home/tutorial/ecp.simg --source /home/tutorial/source.sh
which mpirun
e4s-cl profile list

e4s-cl mpirun -np 4 ./Zoltan

e4s-cl profile delete `e4s-cl profile list -s `

# To use OpenMPI, please run  ./run_e4s-cl_wi4mpi.sh
