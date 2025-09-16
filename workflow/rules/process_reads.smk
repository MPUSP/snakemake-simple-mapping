rule get_genome:
    output:
        fasta="results/get_genome/genome.fasta",
        gff="results/get_genome/genome.gff",
        fai="results/get_genome/genome.fasta.fai",
    params:
        database=config["get_genome"]["database"],
        assembly=config["get_genome"]["assembly"],
    message:
        "parsing genome GFF and FASTA files"
    log:
        path="results/get_genome/log/get_genome.log",
    wrapper:
        "https://raw.githubusercontent.com/MPUSP/mpusp-snakemake-wrappers/refs/heads/main/get_genome"


rule get_fastq:
    input:
        get_fastq,
    output:
        fastq="results/get_fastq/{sample}_{read}.fastq.gz",
    conda:
        "../envs/basic.yml"
    message:
        "obtaining fastq files"
    log:
        "results/get_fastq/{sample}_{read}.log",
    shell:
        "ln -s {input} {output.fastq};"
        "echo 'made symbolic link from {input} to {output.fastq}' > {log}"


rule fastp:
    input:
        sample=get_fastq_pairs,
    output:
        html="results/fastp/{sample}.html",
        json="results/fastp/{sample}.json",
        trimmed=expand(
            "results/fastp/{{sample}}_{read}.fastq.gz",
            read=["read1", "read2"] if is_paired_end() else ["read1"],
        ),
    log:
        "results/fastp/{sample}.log",
    message:
        "trimming and QC filtering reads using fastp"
    params:
        extra=config["processing"]["fastp"]["extra"],
    threads: 2
    resources:
        mem_mb=4096,
    wrapper:
        "v7.0.0/bio/fastp"
