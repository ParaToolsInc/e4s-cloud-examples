import os

# Runs a subset of the model layers to test that the notebook runs in CI, but the output will be incorrect.
FAST_CI_MODE: bool = os.environ.get("FAST_CI_MODE", False)

import glob
import gzip
import json
import math
import os
from pathlib import Path

import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns
import torch
from Bio import SeqIO
from sklearn.metrics import auc, roc_auc_score, roc_curve


## FUNC
def download_data(data_dir="zeroshot_brca1/brca1", commit_hash="3819474bee6c24938016614411f1fa025e542bbe"):
    """Download required data files if they don't exist locally.

    Parameters:
    -----------
    data_dir : str
        Directory to store downloaded files
    commit_hash : str
        GitHub commit hash for data version
    """
    if not os.path.exists(data_dir):
        os.makedirs(data_dir)

    excel_path = os.path.join(data_dir, "41586_2018_461_MOESM3_ESM.xlsx")
    genome_path = os.path.join(data_dir, "GRCh37.p13_chr17.fna.gz")

    if not os.path.exists(excel_path):
        os.system(
            f"wget https://github.com/ArcInstitute/evo2/raw/{commit_hash}/notebooks/brca1/41586_2018_461_MOESM3_ESM.xlsx -O {excel_path}"
        )

    if not os.path.exists(genome_path):
        os.system(
            f"wget https://github.com/ArcInstitute/evo2/raw/{commit_hash}/notebooks/brca1/GRCh37.p13_chr17.fna.gz -O {genome_path}"
        )

    return excel_path, genome_path


def load_genome_sequence(genome_path):
    """Load genome sequence from FASTA file.

    Parameters:
    -----------
    genome_path : str
        Path to the genome FASTA file

    Returns:
    --------
    str
        Genome sequence string
    """
    with gzip.open(genome_path, "rt") as handle:
        for record in SeqIO.parse(handle, "fasta"):
            return str(record.seq)

    raise ValueError("Failed to parse genome sequence")


def load_brca1_data(excel_path):
    """Load and preprocess BRCA1 data from Excel file.

    Parameters:
    -----------
    excel_path : str
        Path to the Excel file

    Returns:
    --------
    pandas.DataFrame
        Processed BRCA1 dataframe
    """
    # Load the dataframe
    brca1_df = pd.read_excel(excel_path, header=2)

    # Select and rename columns
    brca1_df = brca1_df[
        [
            "chromosome",
            "position (hg19)",
            "reference",
            "alt",
            "function.score.mean",
            "func.class",
        ]
    ]

    brca1_df.rename(
        columns={
            "chromosome": "chrom",
            "position (hg19)": "pos",
            "reference": "ref",
            "alt": "alt",
            "function.score.mean": "score",
            "func.class": "class",
        },
        inplace=True,
    )

    # Convert to two-class system
    brca1_df["class"] = brca1_df["class"].replace(["FUNC", "INT"], "FUNC/INT")

    return brca1_df

def sample_data(df, sample_frac=1.0, balanced=True, disable=False, random_state=42):
    """Sample dataframe, optionally with balanced classes.

    Parameters:
    -----------
    df : pandas.DataFrame
        Input dataframe
    sample_frac : float
        Fraction of data to sample
    balanced : bool
        Whether to balance classes
    disable : bool
        Whether to disable sampling
    random_state : int
        Random seed for reproducibility

    Returns:
    --------
    pandas.DataFrame
        Sampled dataframe
    """
    if disable:
        return df

    if balanced:
        # Get the number of rows in the dataframe
        num_rows_minor_class = math.ceil(len(df[df["class"] == "LOF"]) * sample_frac)
        return (
            pd.concat(
                [
                    df[df["class"] == "LOF"].sample(n=num_rows_minor_class, random_state=random_state),
                    df[df["class"] == "FUNC/INT"].sample(n=num_rows_minor_class, random_state=random_state),
                ]
            )
            .sample(frac=1.0, random_state=random_state)
            .reset_index(drop=True)
        )
    else:
        # Calculate the number of rows to sample
        return df.sample(frac=sample_frac, random_state=random_state).reset_index(drop=True)

def parse_sequences(pos, ref, alt, seq_chr17, window_size=8192):
    """Parse reference and variant sequences from the reference genome sequence.

    Parameters:
    -----------
    pos : int
        Position (1-indexed)
    ref : str
        Reference base
    alt : str
        Alternate base
    seq_chr17 : str
        Full chromosome 17 sequence
    window_size : int
        Size of the sequence window to extract

    Returns:
    --------
    tuple
        (reference_sequence, variant_sequence)
    """
    p = pos - 1  # Convert to 0-indexed position
    full_seq = seq_chr17

    ref_seq_start = max(0, p - window_size // 2)
    ref_seq_end = min(len(full_seq), p + window_size // 2)
    ref_seq = seq_chr17[ref_seq_start:ref_seq_end]
    snv_pos_in_ref = min(window_size // 2, p)
    var_seq = ref_seq[:snv_pos_in_ref] + alt + ref_seq[snv_pos_in_ref + 1 :]

    # Sanity checks
    assert len(var_seq) == len(ref_seq)
    assert ref_seq[snv_pos_in_ref] == ref
    assert var_seq[snv_pos_in_ref] == alt

    return ref_seq, var_seq


def generate_fasta_files(df, seq_chr17, output_dir="brca1_fasta_files", window_size=8192):
    """Generate FASTA files for reference and variant sequences.

    Parameters:
    -----------
    df : pandas.DataFrame
        Dataframe with variant information
    seq_chr17 : str
        Chromosome 17 sequence
    output_dir : str
        Output directory for FASTA files
    window_size : int
        Size of sequence window

    Returns:
    --------
    pandas.DataFrame
        Dataframe with added columns for FASTA names
    """
    # Create output directory
    output_dir = Path(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    # Paths for output files
    ref_fasta_path = output_dir / "brca1_reference_sequences.fasta"
    var_fasta_path = output_dir / "brca1_variant_sequences.fasta"

    # Track unique sequences
    ref_sequences = set()
    var_sequences = set()
    ref_seq_to_name = {}

    # Store unique sequences with metadata for writing
    ref_entries = []
    var_entries = []
    ref_names = []
    var_names = []

    # Collect unique reference and variant sequences
    for idx, row in df.iterrows():
        ref_seq, var_seq = parse_sequences(row["pos"], row["ref"], row["alt"], seq_chr17, window_size)

        # Add to sets to ensure uniqueness
        if ref_seq not in ref_sequences:
            ref_sequences.add(ref_seq)
            ref_name = f"BRCA1_ref_pos_{row['pos']}_{row['ref']}_class_{row['class']}"

            ref_entries.append(f">{ref_name}\n{ref_seq}\n")
            ref_names.append(ref_name)
            ref_seq_to_name[ref_seq] = ref_name
        else:
            ref_name = ref_seq_to_name[ref_seq]
            ref_names.append(ref_name)

        if var_seq not in var_sequences:
            var_sequences.add(var_seq)
            var_name = f"BRCA1_var_pos_{row['pos']}_{row['ref']}to{row['alt']}_class_{row['class']}"

            var_entries.append(f">{var_name}\n{var_seq}\n")
            var_names.append(var_name)
        else:
            assert False, "Duplicate variant sequence"

    # Write unique sequences to FASTA files
    with open(ref_fasta_path, "w") as f:
        f.writelines(ref_entries)

    with open(var_fasta_path, "w") as f:
        f.writelines(var_entries)

    # Add FASTA names to dataframe
    df_with_names = df.copy()
    df_with_names["ref_fasta_name"] = ref_names
    df_with_names["var_fasta_name"] = var_names

    print(f"Total unique reference sequences: {len(ref_sequences)}")
    print(f"Total unique variant sequences: {len(var_sequences)}")

    return df_with_names

def check_fp8_support():
    """Check if FP8 is supported on the current GPU.

    FP8 requires compute capability 8.9+ (Ada Lovelace/Hopper architecture or newer).
    """
    if not torch.cuda.is_available():
        return False, "CUDA not available"

    device_props = torch.cuda.get_device_properties(0)
    compute_capability = f"{device_props.major}.{device_props.minor}"
    device_name = device_props.name

    # FP8 is supported on compute capability 8.9+ (Ada Lovelace/Hopper architecture)
    is_supported = (device_props.major > 8) or (device_props.major == 8 and device_props.minor >= 9)

    return is_supported, f"Device: {device_name}, Compute Capability: {compute_capability}"

##


DATA_DIR = "zeroshot_brca1/brca1"
SAMPLE_CONFIG = {"sample_frac": 0.05, "balanced": True, "disable": False, "random_state": 42}

excel_path, genome_path = download_data(DATA_DIR)

seq_chr17 = load_genome_sequence(genome_path)

brca1_df = load_brca1_data(excel_path)

OUTPUT_DIR = "brca1_fasta_files"

brca1_df = sample_data(
    brca1_df,
    sample_frac=SAMPLE_CONFIG["sample_frac"],
    balanced=SAMPLE_CONFIG["balanced"],
    disable=SAMPLE_CONFIG["disable"],
    random_state=SAMPLE_CONFIG["random_state"],
)

brca1_df = generate_fasta_files(brca1_df, seq_chr17, output_dir=OUTPUT_DIR)

EXPERIMENTAL_1b_CHECKPOINT: bool = False
MODEL_SIZE = "1b"  # also try 7b if you have a GPU with more than 32GB of memory

if EXPERIMENTAL_1b_CHECKPOINT and MODEL_SIZE == "1b":
    from bionemo.core.data.load import load

    # This is a new 1b checkpoint that has been fine-tuned on BF16 hardware. It should be able to handle FP8 as well.
    #  this line will download the checkpoint from NGC to your $HOME/.cache/bionemo directory and return the path.
    #  alternatively you can use `CHECKPOINT_PATH=$(download_bionemo_data evo2/1b-8k-bf16:1.0)`  to do the same on the
    #  command line.
    checkpoint_path = load("evo2/1b-8k-bf16:1.0")
else:
    checkpoint_path = Path(f"nemo2_evo2_{MODEL_SIZE}_8k")

    # Check if the directory does not exist or is empty
    if not checkpoint_path.exists() or not any(checkpoint_path.iterdir()):
        print(f"evo2_convert_to_nemo2 --model-path hf://arcinstitute/savanna_evo2_{MODEL_SIZE}_base --model-size {MODEL_SIZE} --output-dir nemo2_evo2_{MODEL_SIZE}_8k")
    else:
        print("Checkpoint directory is not empty. Skipping command.")
## 

# Define output directories for prediction results
output_dir = Path("brca1_fasta_files")
output_dir.mkdir(parents=True, exist_ok=True)

# Save reference and variant sequences to FASTA
ref_fasta_path = output_dir / "brca1_reference_sequences.fasta"
var_fasta_path = output_dir / "brca1_variant_sequences.fasta"

predict_ref_dir = output_dir / "reference_predictions"
predict_var_dir = output_dir / "variant_predictions"
predict_ref_dir.mkdir(parents=True, exist_ok=True)
predict_var_dir.mkdir(parents=True, exist_ok=True)

fp8_supported, gpu_info = check_fp8_support()
print(f"FP8 Support: {fp8_supported}")
print(gpu_info)

# Note: If FP8 is not supported, you may want to disable it in the model config
# The Evo2 config has 'use_fp8_input_projections: True' by default

if FAST_CI_MODE:
    model_subset_option = "--num-layers 4 --hybrid-override-pattern SDH*"
else:
    model_subset_option = ""

fp8_option = "--fp8" if fp8_supported else ""

# Update predict commands to run on the full dataset
predict_ref_command = (
    f"predict_evo2 --fasta {ref_fasta_path} --ckpt-dir {checkpoint_path} "
    f"--output-dir {predict_ref_dir} --model-size {MODEL_SIZE} --tensor-parallel-size 1  {model_subset_option} "
    f"--pipeline-model-parallel-size 1 --context-parallel-size 1 --output-log-prob-seqs {fp8_option}"
)

predict_var_command = (
    f"predict_evo2 --fasta {var_fasta_path} --ckpt-dir {checkpoint_path} "
    f"--output-dir {predict_var_dir} --model-size {MODEL_SIZE} --tensor-parallel-size 1 {model_subset_option} "
    f"--pipeline-model-parallel-size 1 --context-parallel-size 1 --output-log-prob-seqs {fp8_option}"
)
##

## SECTION 6
print(f"predict_ref_command: {predict_ref_command}")
print(f"predict_var_command: {predict_var_command}")
##
