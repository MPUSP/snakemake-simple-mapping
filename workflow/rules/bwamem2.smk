rule bwa_mem2_index:
    input:
        ref=rules.get_genome.output.fasta,
    output:
        multiext(
            "results/bwa_mem2/index/genome",
            ".0123",
            ".amb",
            ".ann",
            ".bwt.2bit.64",
            ".pac",
        ),
    log:
        "results/bwa_mem2/index/genome.log",
    message:
        "build bwa_mem2 index"
    wrapper:
        "v6.2.0/bio/bwa-mem2/index"


rule bwa_mem2:
    input:
        reads=expand(
            "results/fastp/{{sample}}_{read}.fastq.gz",
            read=["read1", "read2"] if is_paired_end() else ["read1"],
        ),
        idx=rules.bwa_mem2_index.output,
    output:
        "results/bwa_mem2/align/{sample}.bam",
    log:
        "results/bwa_mem2/align/{sample}.log",
    message:
        "make bwa_mem2 alignment"
    params:
        extra=config["mapping"]["bwa_mem2"]["extra"],
        sort=config["mapping"]["bwa_mem2"]["sort"],
        sort_order=config["mapping"]["bwa_mem2"]["sort_order"],
        sort_extra=config["mapping"]["bwa_mem2"]["sort_extra"],
    threads: 8
    wrapper:
        "v6.2.0/bio/bwa-mem2/mem"
