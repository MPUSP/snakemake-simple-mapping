# import basic packages
import pandas as pd
from snakemake.utils import validate
from pathlib import Path

# read sample sheet
samples = (
    pd.read_csv(config["samplesheet"], sep="\t", dtype={"sample": str})
    .set_index("sample", drop=False)
    .sort_index()
)


# validate sample sheet and config file
# validate(samples, schema="../../config/schemas/samples.schema.yml")
# validate(config, schema="../../config/schemas/config.schema.yml")


# get fastq files
def get_fastq(wildcards):
    print(wildcards)
    file = Path(samples.loc[wildcards["sample"]][wildcards["read"]])
    if file.is_absolute():
        return file
    else:
        input_dir = Path.absolute(Path.cwd())
        return input_dir / file


# get pairs of fastq files for fastp
def get_fastq_pairs(wildcards):
    return expand(
        "results/get_fastq/{sample}_{read}.fastq.gz",
        sample=wildcards.sample,
        read=(
            ["read1", "read2"]
            if lookup(query="index.loc[{sample}]", within=samples, cols="read2")
            else ["read1"]
        ),
    )
