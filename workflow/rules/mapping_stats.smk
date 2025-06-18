# re-sort reads from mapping regardless if mapper did
# -----------------------------------------------------
rule samtools_sort:
    input:
        get_bam,
    output:
        "results/samtools/sort/{sample}.bam",
    log:
        "results/samtools/sort/{sample}.log",
    params:
        extra=config["mapping"]["samtools_sort"]["extra"],
    threads: 4
    wrapper:
        "v7.0.0/bio/samtools/sort"


# index reads
# -----------------------------------------------------
rule samtools_index:
    input:
        "results/samtools/sort/{sample}.bam",
    output:
        "results/samtools/sort/{sample}.bai",
    log:
        "results/samtools/sort/{sample}_index.log",
    params:
        extra=config["mapping"]["samtools_index"]["extra"],
    threads: 4
    wrapper:
        "v7.0.0/bio/samtools/index"


# convert genome annotation from GFF to BED format
# -----------------------------------------------------
rule gffread_gff:
    input:
        fasta=rules.get_genome.output.fasta,
        annotation=rules.get_genome.output.gff,
    output:
        records="results/get_genome/genome.bed",
    threads: 1
    log:
        "results/get_genome/gffread.log",
    params:
        extra=config["mapping_stats"]["gffread"]["extra"],
    wrapper:
        "v7.0.0/bio/gffread"


# infer experiment type from mapping to features
# -----------------------------------------------------
rule rseqc_infer_experiment:
    input:
        aln="results/samtools/sort/{sample}.bam",
        refgene="results/get_genome/genome.bed",
    output:
        "results/rseqc/infer_experiment/{sample}.txt",
    log:
        "results/rseqc/infer_experiment/{sample}.log",
    params:
        extra="--sample-size 10000",
    wrapper:
        "v7.0.0/bio/rseqc/infer_experiment"


# collect statistics from mapping
# -----------------------------------------------------
rule rseqc_bam_stat:
    input:
        "results/samtools/sort/{sample}.bam",
    output:
        "results/rseqc/bam_stat/{sample}.txt",
    threads: 2
    params:
        extra="--mapq 5",
    log:
        "results/rseqc/bam_stat/{sample}.log",
    wrapper:
        "v7.0.0/bio/rseqc/bam_stat"


# collect statistics from mapping
# -----------------------------------------------------
rule deeptools_coverage:
    input:
        bam="results/samtools/sort/{sample}.bam",
        bai="results/samtools/sort/{sample}.bai",
    output:
        "results/deeptools/coverage/{sample}.bw",
    threads: 4
    params:
        effective_genome_size=config["mapping_stats"]["deeptools_coverage"][
            "genome_size"
        ],
        extra=config["mapping_stats"]["deeptools_coverage"]["extra"],
    log:
        "results/deeptools/coverage/{sample}.log",
    wrapper:
        "v7.0.0/bio/deeptools/bamcoverage"
