# Inf2 Matmult example

This example compiles a matrix multiplication kernel and runs it on an Inf2 node.

The code is based on https://github.com/aws-neuron/aws-neuron-samples/tree/master/torch-neuronx/microbenchmark

To run:
```bash
    sbatch inf2-matmult.sbatch
```

The sbatch script assumes that there is a queue named `inf2` containing inf2 nodes.

The example will take around 5 minutes to run, almost all of which consists of compiling the model.

Output will be something like:

```
    Compilation took 248.9479s, warmup took 0.0304s, benchmark took 27.4902s
    Timed run: overall runtime = 27.4902s, runtime per iteration = 0.0274902s, timed iterations = 1000
    PE TOPS = 78.118
    Test complete
```

Note that there may be an error at the end:
```
2025-Mar-13 22:49:59.915936 174766:174766 ERROR   NRT:nrt_close                               Unexpected runtime state: NRT_STATE_START
```

This error does not appear to be an actual problem and occurs with the unmodified example running in the official Amazon DLAMI.
