#!/usr/bin/env python
import sys
import importlib.metadata
import torch
import bionemo_ir

print("Python:", sys.executable)
print("BioIR module:", bionemo_ir.__file__)

try:
    print("BioIR version:", importlib.metadata.version("bionemo-ir"))
except importlib.metadata.PackageNotFoundError:
    print("BioIR version: no installed distribution metadata")

print("PyTorch:", torch.__version__)
print("PyTorch CUDA:", torch.version.cuda)
print("CUDA available:", torch.cuda.is_available())

assert torch.cuda.is_available(), "This Python environment cannot access CUDA"

for i in range(torch.cuda.device_count()):
    p = torch.cuda.get_device_properties(i)
    print(f"GPU {i}: {p.name}, {p.total_memory / 2**30:.1f} GiB")

