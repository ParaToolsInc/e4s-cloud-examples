# Trn1 MNIST single-node multi-worker example

This example trains a multi-layer perceptron on the MNIST dataset. 

The code is based on https://github.com/aws-neuron/aws-neuron-samples/tree/master/torch-neuronx/training/mnist_mlp. Specifically, the example described at https://awsdocs-neuron.readthedocs-hosted.com/en/latest/frameworks/torch/torch-neuronx/tutorials/training/mlp.html#multi-worker-data-parallel-mlp-training-using-torchrun is modified to be launchable through Slurm.

To run:
```bash
    sbatch mnist.sbatch
```

The sbatch script assumes that there is a queue named `trn1` containing trn1 nodes.

Warnings that state:

```
/opt/aws_neuron_venv_pytorch/lib/python3.10/site-packages/torch/cuda/__init__.py:716: UserWarning: Can't initialize NVML
```

are expected as trn1 nodes do not support NVML because they do not have NVIDIA GPUs.


