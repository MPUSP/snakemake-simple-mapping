# fetch genome from NCBI or Ensemble
# -----------------------------------------------------
rule get_genome:
    output:
        fasta="results/get_genome/genome.fasta",
        gff="results/get_genome/genome.gff",
        fai="results/get_genome/genome.fasta.fai",
    params:
        database=config["get_genome"]["database"],
        assembly=config["get_genome"]["assembly"],
    message:
        """--- Parsing genome GFF and FASTA files."""
    log:
        path="results/get_genome/log/get_genome.log",
    wrapper:
        "https://raw.githubusercontent.com/MPUSP/mpusp-snakemake-wrappers/refs/heads/main/get_genome"


# get fastq files according to sample name
# -----------------------------------------------------
rule get_fastq:
    input:
        get_fastq,
    output:
        fastq="results/get_fastq/{sample}_{read}.fastq.gz",
    conda:
        "../envs/basic.yml"
    message:
        """--- Obtaining fastq files."""
    log:
        "results/get_fastq/{sample}_{read}.log",
    shell:
        "ln -s {input} {output.fastq};"
        "echo 'made symbolic link from {input} to {output.fastq}' > {log}"


# fastp trimming and QC filtering
# -----------------------------------------------------
# rule fastp_se:
#     input:
#         sample=get_fastq_pairs,
#     output:
#         html="results/fastp/{sample}.html",
#         json="results/fastp/{sample}.json",
#         trimmed="results/fastp/{sample}_read1.fastq.gz",
#     log:
#         "results/fastp/{sample}.log"
#     params:
#         extra=""
#     threads: 2
#     wrapper:
#         "v7.0.0/bio/fastp"


rule fastp_pe:
    input:
        sample=get_fastq_pairs,
    output:
        html="results/fastp/{sample}.html",
        json="results/fastp/{sample}.json",
        trimmed=[
            "results/fastp/{sample}_read1.fastq.gz",
            "results/fastp/{sample}_read2.fastq.gz",
        ],
    log:
        "results/fastp/{sample}.log",
    params:
        extra="",
    threads: 2
    wrapper:
        "v7.0.0/bio/fastp"
