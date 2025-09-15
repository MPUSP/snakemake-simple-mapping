rule bcftools_pileup:
    input:
        alignments="results/samtools/sort/{sample}.bam",
        ref=rules.get_genome.output.fasta,
        index=rules.get_genome.output.fai,
    output:
        pileup="results/bcftools/pileup/{sample}.bcf",
    params:
        uncompressed_bcf=config["variant_calling"]["bcftools_pileup"]["uncompressed"],
        extra=config["variant_calling"]["bcftools_pileup"]["extra"],
    message:
        "create pileups from BAM files using bcftools"
    log:
        "results/bcftools/pileup/{sample}.log",
    wrapper:
        "v7.0.0/bio/bcftools/mpileup"


rule bcftools_call:
    input:
        pileup="results/bcftools/pileup/{sample}.bcf",
    output:
        calls="results/bcftools/call/{sample}.bcf",
    params:
        uncompressed_bcf=config["variant_calling"]["bcftools_call"]["uncompressed"],
        caller=config["variant_calling"]["bcftools_call"]["caller"],
        extra=config["variant_calling"]["bcftools_call"]["extra"],
    message:
        "call variants from pileups using bcftools"
    log:
        "results/bcftools/call/{sample}.log",
    wrapper:
        "v7.0.0/bio/bcftools/call"


rule bcftools_view:
    input:
        "results/{caller}/call/{sample}.bcf",
    output:
        "results/{caller}/call/{sample}_all.vcf",
    log:
        "results/{caller}/call/{sample}_view.log",
    message:
        "generate vcf from bcf files"
    params:
        extra=config["variant_calling"]["bcftools_view"]["extra"],
    wrapper:
        "v7.0.0/bio/bcftools/view"


rule bcftools_filter:
    input:
        "results/{caller}/call/{sample}.bcf",
    output:
        "results/{caller}/call/{sample}_variants.vcf",
    log:
        "results/{caller}/call/{sample}_variants.log",
    message:
        "filter bcf file to only export called variants"
    params:
        filter=config["variant_calling"]["bcftools_filter"]["filter"],
        extra=config["variant_calling"]["bcftools_filter"]["extra"],
    wrapper:
        "v7.0.0/bio/bcftools/filter"


rule bcftools_stats:
    input:
        "results/{caller}/call/{sample}.bcf",
    output:
        "results/{caller}/call/{sample}_stats.txt",
    message:
        "generate text based stats from bcf files"
    log:
        "results/{caller}/call/{sample}_stats.log",
    wrapper:
        "v7.0.0/bio/bcftools/stats"
