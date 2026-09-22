#!/bin/bash -e

# Use available partition.
PARTITION=lizard
NODES=2
NTASKS=4
mpirun \
    --partition="$PARTITION" \
    --nodes="$NODES" \
    -n "$NTASKS" \
    ./ex50 \
    -da_grid_x 120 \
    -da_grid_y 120 \
    -pc_type lu \
    -pc_factor_mat_solver_type superlu_dist \
    -ksp_monitor \
    -ksp_view
