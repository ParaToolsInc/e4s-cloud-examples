#!/bin/bash -e
horovodrun -np 8 python3 src/pytorch_mnist.py --epochs 2 --no-cuda
