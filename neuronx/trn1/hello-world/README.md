# Trn1 Hello World example

This example confirms that multi-worker job launching of PyTorch NeuronX on trn1 is working.

The code is based on https://github.com/aws-neuron/aws-neuron-samples/tree/master/torch-neuronx/training/mnist_mlp with model code removed.

To run:
```bash
    sbatch xla-hello.sbatch
```

The sbatch script assumes that there is a queue named `trn1` containing trn1 nodes.

Warnings that state:

```
/opt/aws_neuron_venv_pytorch/lib/python3.10/site-packages/torch/cuda/__init__.py:716: UserWarning: Can't initialize NVML
```

are expected as trn1 nodes do not support NVML because they do not have NVIDIA GPUs.

Output is of the form:

```
{hostname}: Hello from {rank} of {world_size}
```

There should be one output line for each Trainium device exposed, 32 on a trn1.32xlarge

