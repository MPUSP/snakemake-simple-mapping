rule get_genome:
    input:
        fasta=lambda wildcards: (
            config["get_genome"]["fasta"]
            if config["get_genome"]["database"] == "manual"
            else []
        ),
        gff=lambda wildcards: (
            config["get_genome"]["gff"]
            if config["get_genome"]["database"] == "manual"
            else []
        ),
    output:
        fasta="results/get_genome/genome.fasta",
        gff="results/get_genome/genome.gff",
        fai="results/get_genome/genome.fasta.fai",
    log:
        path="results/get_genome/log/get_genome.log",
    params:
        database=config["get_genome"]["database"],
        assembly=config["get_genome"]["assembly"],
        gff_source_types=config["get_genome"]["gff_source_type"],
    message:
        "parsing genome GFF and FASTA files"
    wrapper:
        "https://raw.githubusercontent.com/MPUSP/mpusp-snakemake-wrappers/refs/heads/main/get_genome"


rule get_fastq:
    input:
        get_fastq,
    output:
        fastq="results/get_fastq/{sample}_{read}.fastq.gz",
    log:
        "results/get_fastq/{sample}_{read}.log",
    conda:
        "../envs/basic.yml"
    message:
        "obtaining fastq files"
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
    threads: 2
    resources:
        mem_mb=4096,
    params:
        extra=config["processing"]["fastp"]["extra"],
    message:
        "trimming and QC filtering reads using fastp"
    wrapper:
        "v9.4.1/bio/fastp"


rule fastplong:
    input:
        sample=get_fastq_pairs,
    output:
        html="results/fastplong/{sample}.html",
        json="results/fastplong/{sample}.json",
        trimmed=expand(
            "results/fastplong/{{sample}}_{read}.fastq.gz",
            read=["read1", "read2"] if is_paired_end() else ["read1"],
        ),
    log:
        "results/fastplong/{sample}.log",
    conda:
        "../envs/fastplong.yml"
    threads: 2
    resources:
        mem_mb=4096,
    params:
        extra=config["processing"]["fastplong"]["extra"],
    message:
        "trimming and QC filtering reads using fastplong"
    shell:
        """
        fastplong \
            --thread {threads} \
            --in {input.sample} \
            --out {output.trimmed} \
            --html {output.html} \
            --json {output.json} \
            {params.extra} \
            >{log} 2>&1
        """
