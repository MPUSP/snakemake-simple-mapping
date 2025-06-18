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
    threads: 1
    params:
        extra="--mapq 5",
    log:
        "results/rseqc/bam_stat/{sample}.log",
    wrapper:
        "v7.0.0/bio/rseqc/bam_stat"
