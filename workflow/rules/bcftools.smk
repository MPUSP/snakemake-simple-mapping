# create pileups from BAM files using bcftools
# -----------------------------------------------------
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
    log:
        "results/bcftools/pileup/{sample}.log",
    wrapper:
        "v7.0.0/bio/bcftools/mpileup"


# call variants from pileups using bcftools
# -----------------------------------------------------
rule bcftools_call:
    input:
        pileup="results/bcftools/pileup/{sample}.bcf",
    output:
        calls="results/bcftools/call/{sample}.bcf",
    params:
        uncompressed_bcf=config["variant_calling"]["bcftools_call"]["uncompressed"],
        caller=config["variant_calling"]["bcftools_call"]["caller"],
        extra=config["variant_calling"]["bcftools_call"]["extra"],
    log:
        "results/bcftools/call/{sample}.log",
    wrapper:
        "v7.0.0/bio/bcftools/call"


# generate vcf from bcf files
# -----------------------------------------------------
rule bcftools_view:
    input:
        "results/bcftools/call/{sample}.bcf",
    output:
        "results/bcftools/call/{sample}.vcf",
    log:
        "results/bcftools/call/{sample}_view.log",
    params:
        extra="",
    wrapper:
        "v7.0.0/bio/bcftools/view"


# generate text based stats from bcf files
# -----------------------------------------------------
rule bcftools_stats:
    input:
        "results/bcftools/call/{sample}.bcf",
    output:
        "results/bcftools/call/{sample}_stats.txt",
    log:
        "results/bcftools/call/{sample}_stats.log",
    wrapper:
        "v7.0.0/bio/bcftools/stats"
