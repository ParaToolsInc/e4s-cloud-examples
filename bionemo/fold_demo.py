#!/usr/bin/env python3
import argparse
import json
import os
import time
from pathlib import Path

import torch
import bionemo_ir

from bionemo_ir.data.schemas import InputRequest, MSARecord, Polymer
from bionemo_ir.pipeline.processor.engine_proc import (
    EngineProcessorConfig,
    build_processor,
)
from bionemo_ir.pipeline.stages.configs import (
    FeatureGeneratorStageConfig,
    WriterStageConfig,
)

SEQUENCE = (
    "ACKIENIKYKGKEVESKLGSQLIDIFNDLDRAKEEYDKLSSPEFIAKFGDWIN"
    "DEVERNVNEDGEPLLIQDVRQDSSKHYFFILKNGERFDLLTR"
)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--repeats", type=int, default=3)
    parser.add_argument("--steps", type=int, default=50)
    parser.add_argument("--out", default="fold_output")
    parser.add_argument("--msa", help="Optional full T1031 alignment in A3M format")
    args = parser.parse_args()

    assert torch.cuda.is_available(), "CUDA is unavailable in this Python session"
    assert args.repeats > 0 and args.steps > 0

    outdir = Path(args.out)
    outdir.mkdir(parents=True, exist_ok=True)
    torch.cuda.set_device(0)

    print(f"PID: {os.getpid()}", flush=True)
    print(f"GPU: {torch.cuda.get_device_name(0)}", flush=True)
    print(f"Sequence length: {len(SEQUENCE)} residues", flush=True)
    print(f"Predictions: {args.repeats}; sampling steps: {args.steps}", flush=True)

    config = EngineProcessorConfig(
        model_source="boltz-2",
        executor_backend=None,
        runtime_args={
            "num_sampling_steps": args.steps,
            "diffusion_samples": 1,
        },
        engine_kwargs={"profile_inference": True},
        feature_generator_stage=FeatureGeneratorStageConfig(
            init_context={"random_seed": 42},
        ),
        writer_stage=WriterStageConfig(
            output_path=str(outdir),
            format=["pdb", "cif"],
        ),
    )

    print("Building pipeline; first run may download weights/metadata...", flush=True)
    processor = build_processor(config)
    summaries = []

    for i in range(args.repeats):
        record_id = f"T1031_run_{i + 1:02d}"
        msa = (
            MSARecord(path=str(Path(args.msa).resolve()), format="a3m")
            if args.msa
            else MSARecord(content=f">T1031\n{SEQUENCE}\n", format="a3m")
        )

        request = InputRequest(
            input_id=record_id,
            polymers=[
                Polymer(
                    polymer_type="protein",
                    chain_id=["A1"],
                    sequence=SEQUENCE,
                    msas=[msa],
                )
            ],
        )

        torch.cuda.reset_peak_memory_stats()
        torch.cuda.synchronize()
        start = time.perf_counter()

        with torch.inference_mode():
            row = processor([
                {
                    "record": request,
                    "__record_id": record_id,
                    "random_seed": 42 + i,
                }
            ])[0]

        torch.cuda.synchronize()
        elapsed = time.perf_counter() - start
        scores = json.loads(row["scores"])

        structure = Path(row["output_path"])
        assert structure.is_file() and structure.stat().st_size > 0

        plddt = scores.get("plddt")
        summary = {
            "record_id": record_id,
            "output_path": str(structure),
            "wall_time_s": round(elapsed, 3),
            "model_inference_time_s": row.get("model_inference_time"),
            "peak_torch_allocated_GiB": round(
                torch.cuda.max_memory_allocated() / 2**30, 3
            ),
            "ptm": scores.get("ptm"),
            "mean_plddt_raw": (
                sum(plddt) / len(plddt) if plddt is not None and len(plddt) else None
            ),
        }
        summaries.append(summary)
        print(json.dumps(summary, indent=2), flush=True)

    (outdir / "demo_summary.json").write_text(
        json.dumps(summaries, indent=2)
    )
    print(f"Finished. Structures and scores are in {outdir.resolve()}", flush=True)

if __name__ == "__main__":
    main()

