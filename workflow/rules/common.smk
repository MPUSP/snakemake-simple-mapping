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


# determine input type
def is_paired_end():
    if samples["read2"].isna().all():
        return False
    elif samples["read2"].notna().all():
        return True
    else:
        raise ValueError(
            f"Some samples seem to have a read2 fastq file, while others have only a "
            + "read1 fastq file. \nYou may not mix single-end and paired-end samples."
        )


# get fastq files
def get_fastq(wildcards):
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
        read=["read1", "read2"] if is_paired_end() else ["read1"],
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
    result += expand(
        "results/fastqc/{sample}_{read}_fastqc.{ext}",
        sample=samples.index,
        read=["read1", "read2"] if is_paired_end() else ["read1"],
        ext=["html", "zip"],
    )
    result += expand(
        "results/{tool}/align/{sample}.bam",
        sample=samples.index,
        tool=config["mapping"]["tool"],
    )
    result += expand(
        "results/fastp/{sample}.json",
        sample=samples.index,
    )
    result += expand(
        "results/rseqc/{tool}/{sample}.txt",
        sample=samples.index,
        tool=["infer_experiment", "bam_stat"],
    )
    result += expand(
        "results/deeptools/coverage/{sample}.bw",
        sample=samples.index,
    )
    result += expand(
        "results/{caller}/call/{sample}{ext}",
        sample=samples.index,
        caller=["bcftools", "freebayes"],
        ext=["_stats.txt", "_all.vcf", "_variants.vcf"],
    )
    return result
