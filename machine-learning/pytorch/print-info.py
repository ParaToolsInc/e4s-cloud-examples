#!/usr/bin/env python3

import torch

print("PyTorch Version:", torch.__version__)
print("# Devices:", torch.cuda.device_count())
print("# Current Device:", torch.cuda.get_device_name(torch.cuda.current_device()))
