rule bcftools_pileup:
    input:
        alignments="results/samtools/sort/{sample}.bam",
        ref=rules.get_genome.output.fasta,
        index=rules.get_genome.output.fai,
    output:
        pileup="results/bcftools/pileup/{sample}.bcf",
    log:
        "results/bcftools/pileup/{sample}.log",
    params:
        uncompressed_bcf=config["variant_calling"]["bcftools_pileup"]["uncompressed"],
        extra=config["variant_calling"]["bcftools_pileup"]["extra"],
    message:
        "create pileups from BAM files using bcftools"
    wrapper:
        "v9.4.1/bio/bcftools/mpileup"


rule bcftools_call:
    input:
        pileup="results/bcftools/pileup/{sample}.bcf",
    output:
        calls="results/bcftools/call/{sample}.bcf",
    log:
        "results/bcftools/call/{sample}.log",
    params:
        uncompressed_bcf=config["variant_calling"]["bcftools_call"]["uncompressed"],
        caller=config["variant_calling"]["bcftools_call"]["caller"],
        extra=config["variant_calling"]["bcftools_call"]["extra"],
    message:
        "call variants from pileups using bcftools"
    wrapper:
        "v9.4.1/bio/bcftools/call"


rule bcftools_view:
    input:
        "results/{caller}/call/{sample}.bcf",
    output:
        "results/{caller}/call/{sample}_all.vcf",
    log:
        "results/{caller}/call/{sample}_view.log",
    params:
        extra=config["variant_calling"]["bcftools_view"]["extra"],
    message:
        "generate vcf from bcf files"
    wrapper:
        "v9.4.1/bio/bcftools/view"


rule bcftools_filter:
    input:
        "results/{caller}/call/{sample}.bcf",
    output:
        "results/{caller}/call/{sample}_variants.vcf",
    log:
        "results/{caller}/call/{sample}_variants.log",
    params:
        filter=config["variant_calling"]["bcftools_filter"]["filter"],
        extra=config["variant_calling"]["bcftools_filter"]["extra"],
    message:
        "filter bcf file to only export called variants"
    wrapper:
        "v9.4.1/bio/bcftools/filter"


rule bcftools_stats:
    input:
        "results/{caller}/call/{sample}.bcf",
    output:
        "results/{caller}/call/{sample}_stats.txt",
    log:
        "results/{caller}/call/{sample}_stats.log",
    message:
        "generate text based stats from bcf files"
    wrapper:
        "v9.4.1/bio/bcftools/stats"
