# build bowtie2 index
# -----------------------------------------------------
rule bowtie2_build:
    input:
        ref=rules.get_genome.output.fasta,
    output:
        multiext(
            "results/bowtie2/build/genome",
            ".1.bt2",
            ".2.bt2",
            ".3.bt2",
            ".4.bt2",
            ".rev.1.bt2",
            ".rev.2.bt2",
        ),
    log:
        "results/bowtie2/build/build.log",
    params:
        extra=config["mapping"]["bowtie2"]["index"],
    threads: 1
    wrapper:
        "v7.0.0/bio/bowtie2/build"


# make bowtie2 alignment
# -----------------------------------------------------
rule bowtie2_align:
    input:
        sample=expand(
            "results/fastp/{{sample}}_{read}.fastq.gz",
            read=["read1", "read2"] if is_paired_end() else ["read1"],
        ),
        idx=rules.bowtie2_build.output,
    output:
        "results/bowtie2/align/{sample}.bam",
    log:
        "results/bowtie2/align/{sample}.log",
    params:
        extra=config["mapping"]["bowtie2"]["extra"],
    threads: int(workflow.cores * 0.25)
    wrapper:
        "v7.0.0/bio/bowtie2/align"
