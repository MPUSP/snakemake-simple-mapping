rule minimap2_index:
    input:
        target=rules.get_genome.output.fasta,
    output:
        index="results/minimap2/index/genome.mmi",
    log:
        "results/minimap2/index/genome.log",
    params:
        extra=config["mapping"]["minimap2"]["index"],
    threads: 1
    wrapper:
        "v7.2.0/bio/minimap2/index"


rule minimap2_align:
    input:
        target=rules.minimap2_index.output.index,
        query=expand(
            "results/fastp/{{sample}}_{read}.fastq.gz",
            read=["read1", "read2"] if is_paired_end() else ["read1"],
        ),
    output:
        "results/minimap2/align/{sample}/mapped.bam",
    log:
        "results/minimap2/align/{sample}/mapped.log",
    params:
        extra=config["mapping"]["minimap2"]["extra"],
        sorting=config["mapping"]["minimap2"]["sorting"],
        sort_extra=config["mapping"]["minimap2"]["sort_extra"],
    threads: 8
    wrapper:
        "v7.2.0/bio/minimap2/aligner"
