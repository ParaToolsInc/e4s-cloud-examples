#!/usr/bin/env python
# coding: utf-8

# # Microbenchmarking Neuron Devices (Trn1/Inf2)

# ## Introduction
# 
# This guide reviews the best practices for benchmarking performance of Neuron devices. It shows how to separate compilation and execution time, how to isolate the device time from the end-to-end execution time, how to warm-up the device, and covers few pitfalls one should be aware of. This guide provides an example code, in PyTorch, that can be used as a template for measuring performance.
# 
# This Jupyter notebook should be run on a Trn1/Inf2 instance (trn1.2xlarge/inf2.xlarge or larger).

# Verify that this Jupyter notebook is running the Python kernel environment that was set up according to the [PyTorch Installation Guide](https://awsdocs-neuron.readthedocs-hosted.com/en/latest/general/setup/torch-neuronx.html#setup-torch-neuronx). You can select the kernel from the 'Kernel -> Change Kernel' option on the top of this Jupyter notebook page.

# ## Example
# 
# As a motivating example, assume we would like to measure the max throughput of the device when executing matrix multiplication:
# 
# `nn.Linear(in_features=n, out_features=n, bias=is_add_bias)`
# 
# Note that nn.Linear can add bias; we will touch on that part later.
# 
# First we will parametrize the microbenchmark run as follows (those parameters can be modified as needed):
# 

# In[1]:

print("Starting test...")

import sys

print(f"Python interpreter: {sys.executable}")  

# Matrix multiplication of size [BATCH_SIZE, MATRIX_DIM, MATRIX_DIM]x[BATCH_SIZE, MATRIX_DIM, MATRIX_DIM]
BATCH_SIZE          = 1
MATRIX_DIM          = 1024
# How many times matrix multiplication is ran in a single loop (recommend using a large number to amortize runtime and framework overheads)
LOOP_COUNT          = 1000
# Number of timed iterations (recommend using a large number to filter noise)
N_TIMED_ITERATIONS  = 1000
# Add bias after matrix multiplication (recommended for numerical stability)
ADD_BIAS            = True
# Additional flags to pass to the compiler
NEURON_CC_FLAGS     = ""


# We recommend adding bias for numerical stability (avoiding NaNs in computation). Numerical issues are reported back to the user, which can slow down total runtime. For best performance use large matrix sizes (for high utilization), and large loop/iteration counts (to minimize overheads).

# ### Initial Version
# 
# Let’s write a simple Module that will exercise the Linear layer in a loop (see below). We want to repeat the computation to amortize overheads.

# In[2]:

print("Importing PyTorch")

import torch
import torch.nn as nn

print("Done importing PyTorch")

@torch.no_grad()
class Matmult(nn.Module):

    def __init__(self, n, is_add_bias, loop_count):
        super().__init__()
        self.loop_count = loop_count
        self.matmult = nn.Linear(in_features=n, out_features=n, bias=is_add_bias)

    def forward(self, x):
        out = self.matmult(x)
        for i in range(1, self.loop_count):
            out = self.matmult(out)
        return out.mean()


# Note that we feed the result of the previous matmult to the current one. This is done to make sure we use the result from each matrix multiplication. If, for example, we would have tried to simply repeat the same computation inside the loop, the compiler would have optimized all but the last iteration out:
# 
# ```
#     def forward(self, x):
#         input = x
#         for i in range(0, self.loop_count):
#             out = self.matmult(input) 
# ```

# ### Counting time
# 
# Make sure to use a sufficiently-granular counter. We recommend using time.perf_counter, which uses the clock with the highest available resolution. The Neuron microbenchmark samples, contains a simple utility that is adequate for perf timing. Using the timer class, we can decorate the code to measure runtime of each section.

# In[3]:


import ubench_utils 


# ### Using PyTorch-Neuron trace
# There are two methods to instantiate execution on neuron devices: (1) using [Neuron XLA device API](https://awsdocs-neuron.readthedocs-hosted.com/en/latest/frameworks/torch/torch-neuronx/programming-guide/training/pytorch-neuron-programming-guide.html), and (2) using [PyTorch-Neuron trace API](https://awsdocs-neuron.readthedocs-hosted.com/en/latest/frameworks/torch/torch-neuron/api-compilation-python-api.html). For benchmarking, we prefer using the PyTorch-Neuron trace, because it introduces minimal runtime and application overheads (see explanation of the [Lazy mode](https://awsdocs-neuron.readthedocs-hosted.com/en/latest/frameworks/torch/torch-neuronx/programming-guide/training/pytorch-neuron-programming-guide.html#understand-the-lazy-mode-in-pytorch-neuron) operation of Neuron XLA).

# In[4]:

print("Importing torch_neuronx")
import torch_neuronx
print("Done importing torch_neuronx")

# Create the model
model = Matmult(MATRIX_DIM, ADD_BIAS, LOOP_COUNT)
# Create sample input
matrix_cpu = torch.randn([BATCH_SIZE, MATRIX_DIM, MATRIX_DIM], dtype=torch.float32)


# PyTorch-Neuron trace also makes it easy to separate compilation:

# In[5]:


print("Compiling model...")
#Compile model
with ubench_utils.Timer() as compilation_time:
    trace = torch_neuronx.trace(model, 
                                matrix_cpu, 
                                compiler_args=NEURON_CC_FLAGS)
print("Done compiling model")

# Save model to disk 
print("Saving model...")
torch.jit.save(trace, 'model.pt')
print("Done saving model")


#  and execution:

# In[6]:


# Load model on NeuronCore
print("Loading model...")
neuron_model = torch.jit.load('model.pt')
print("Done loading model")

# Warmup
print("Warming up...")
with ubench_utils.Timer() as warmup_model_time:
    out = neuron_model(matrix_cpu)
print("Done warming up")

# Timed run
print("Running model...")
with ubench_utils.Timer() as benchmark_time:
    for i in range(N_TIMED_ITERATIONS):
        out = neuron_model(matrix_cpu)
print("Done running model")


# We can then report time taken for each step:

# In[7]:


print("""Compilation took {:.4f}s, warmup took {:.4f}s, benchmark took {:.4f}s"""
     .format(compilation_time(), 
             warmup_model_time(), 
             benchmark_time()))  


# For the timed run, we can calculate how much time each execution took, and what is the achieved performance:

# In[8]:


print("Timed run: overall runtime = {:2g}s, runtime per iteration = {:2g}s, timed iterations = {}"
    .format(benchmark_time(),
            benchmark_time() / N_TIMED_ITERATIONS, N_TIMED_ITERATIONS))

# Total operation count
top_per_run = BATCH_SIZE*(MATRIX_DIM**3)*N_TIMED_ITERATIONS*LOOP_COUNT*2
# Tera operations per second (TOPS)
tops = (top_per_run/benchmark_time())/1e12
print("PE TOPS = {:2g}".format(tops))

print("Test complete")

# ## Full example
# 
# A complete, parametrizable example of matrix multiplication benchmarks is in [matmult_linear.py](matmult_linear.py). It allows setting the batch size, matrix size, loop and iteration count, as well as additional parameters (listed using `python matmult_linear.py -h`). Example usage:
# 
# ```
# python matmult_linear.py --batch_size 1 --matrix_dim 1024 --loop_count 1000 --num_warmup_iterations 2 --num_timed_iterations 1000 --add_bias
# ```
# 
# If you ran the code is notebook, please terminate it before attempting to run any other code on the neuron devices.

# ## Benchmarking other workloads
# 
# The methodology presented above can be extended to other workloads (even full models), using the following steps:
# 
# - Modify the `class Matmult` to reflect your workload.
# - Modify the parameters (e.g. `BATCH_SIZE`, `MATRIX_DIM`) to reflect your workload.
# - Modify the input (e.g. `matrix_cpu`) as necessary for your workload.
# - Modify the `top_per_run` formula according to your workload.
