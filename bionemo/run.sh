#!/bin/bash
python3 ./setup.sh
time evo2_convert_to_nemo2 --model-path hf://arcinstitute/savanna_evo2_1b_base --model-size 1b --output-dir nemo2_evo2_1b_8k
time predict_evo2 --fasta brca1_fasta_files/brca1_reference_sequences.fasta --ckpt-dir nemo2_evo2_1b_8k --output-dir brca1_fasta_files/reference_predictions --model-size 1b --tensor-parallel-size 1   --pipeline-model-parallel-size 1 --context-parallel-size 1 --output-log-prob-seqs --fp8
time predict_evo2 --fasta brca1_fasta_files/brca1_variant_sequences.fasta --ckpt-dir nemo2_evo2_1b_8k --output-dir brca1_fasta_files/variant_predictions --model-size 1b --tensor-parallel-size 1  --pipeline-model-parallel-size 1 --context-parallel-size 1 --output-log-prob-seqs --fp8
