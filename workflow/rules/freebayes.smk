rule freebayes:
    input:
        alns="results/samtools/sort/{sample}.bam",
        idxs="results/samtools/sort/{sample}.bai",
        ref=rules.get_genome.output.fasta,
        refidx=rules.get_genome.output.fai,
    output:
        bcf="results/freebayes/call/{sample}.bcf",
    params:
        extra=config["variant_calling"]["freebayes"]["extra"],
    log:
        "results/freebayes/call/{sample}.log",
    message:
        "call variants using freebayes"
    threads: 4
    wrapper:
        "v7.0.0/bio/freebayes"
