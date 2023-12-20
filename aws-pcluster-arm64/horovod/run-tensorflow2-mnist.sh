#!/bin/bash -e

horovodrun -np 8 python3 src/tensorflow2_mnist.py
