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
validate(samples, schema="../../config/schemas/samples.schema.yml")
validate(config, schema="../../config/schemas/config.schema.yml")


# get fastq files
def get_fastq(wildcards):
    file = samples.loc[wildcards["sample"]][wildcards["read"]]
    if pd.isna(file):
        raise IOError(
            f"Sample '{wildcards['sample']}' does not have a '{wildcards['read']}' "
            + "fastq file, although other samples have it.\nYou may not mix single-"
            + "end and paired-end samples."
        )
    else:
        file = Path(file)
    if file.is_absolute():
        return file
    else:
        input_dir = Path.absolute(Path.cwd())
        return input_dir / file


# get pairs of fastq files for fastp
def get_fastq_pairs(wildcards):
    file = samples.loc[wildcards["sample"]]["read2"]
    return expand(
        "results/get_fastq/{sample}_{read}.fastq.gz",
        sample=wildcards.sample,
        read=["read1"] if pd.isna(file) else ["read1", "read2"],
    )


# get pairs of fastq files for fastp
def get_bam(wildcards):
    return expand(
        "results/{tool}/align/{sample}.bam",
        sample=wildcards.sample,
        tool=config["mapping"]["tool"],
    )


# get input for multiqc
def get_multiqc_input(wildcards):
    result = []
    for s in samples.iterrows():
        if pd.isna(s[1]["read1"]):
            raise IOError(f"Sample {s[1]['sample']} does not have a read1 fastq file.")
        result += expand(
            "results/fastqc/{sample}_{read}_fastqc.{ext}",
            sample=s[1]["sample"],
            read=["read1"] if pd.isna(s[1]["read2"]) else ["read1", "read2"],
            ext=["html", "zip"],
        )
        result += expand(
            "results/{tool}/align/{sample}.bam",
            sample=s[1]["sample"],
            tool=config["mapping"]["tool"],
        )
        result += expand(
            "results/fastp/{sample}.json",
            sample=s[1]["sample"],
        )
        result += expand(
            "results/rseqc/{tool}/{sample}.txt",
            sample=s[1]["sample"],
            tool=["infer_experiment", "bam_stat"],
        )
        result += expand(
            "results/deeptools/coverage/{sample}.bw",
            sample=s[1]["sample"],
        )
        result += expand(
            "results/bcftools/call/{sample}{ext}",
            sample=s[1]["sample"],
            ext=["_stats.txt", ".vcf"],
        )
    return result
