#!/bin/bash
#mpirun -np 4 tau_exec -T cupti -cupti -ebs ./tea_leaf
mpirun -np 4 ./tea_leaf
