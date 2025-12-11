rule star_index:
    input:
        fasta=rules.get_genome.output.fasta,
    output:
        directory("results/star/index/"),
    threads: 1
    params:
        extra=config["mapping"]["star"]["index"],
    log:
        "results/star/index/index.log",
    message:
        "build star index"
    wrapper:
        "v7.2.0/bio/star/index"


rule star_align:
    input:
        fq1="results/fastp/{sample}_read1.fastq.gz",
        fq2="results/fastp/{sample}_read2.fastq.gz" if is_paired_end() else [],
        idx=rules.star_index.output,
    output:
        aln="results/star/align/{sample}/mapped.bam",
        log_final="results/star/align/{sample}/Log.final.out",
    log:
        "results/star/align/{sample}/mapped.log",
    message:
        "make star alignment"
    params:
        extra=config["mapping"]["star"]["extra"],
    threads: 8
    wrapper:
        "v7.2.0/bio/star/align"
