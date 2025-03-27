import sys
import os
import socket

# PyTorch
import torch
import torch.distributed as dist

# XLA (Accelerated Linear Algebra)
import torch_xla.core.xla_model as xm
import torch_xla.runtime as xr

# Initialize XLA process group for torchrun
import torch_xla.distributed.xla_backend

def main():
    torch.distributed.init_process_group('xla')

    world_size = xr.world_size()
    rank = xr.global_ordinal()
    is_master = xm.is_master_ordinal()
    hostname=socket.gethostname()

    print(f'{hostname}: Hello from {rank} of {world_size}, {"MASTER" if is_master else ""}')

    dist.barrier()

if __name__ == '__main__':
    main()


