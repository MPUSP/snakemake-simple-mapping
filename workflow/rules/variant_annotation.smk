rule vep_prepare:
    input:
        gff=rules.get_genome.output.gff,
    output:
        gff="results/get_genome/genome.gff.gz",
        index="results/get_genome/genome.gff.gz.tbi",
    conda:
        "../envs/vep.yml"
    log:
        "results/get_genome/tabix.log",
    threads: 1
    shell:
        "grep -v '#' {input.gff} | sort -k1,1 -k4,4n -k5,5n -t$'\t' | bgzip -c > {output.gff};"
        "tabix -p gff {output.gff}"


rule vep_plugins:
    output:
        directory("resources/vep/plugins"),
    params:
        release=100,
    log:
        "resources/vep/plugins/plugins.log",
    wrapper:
        "v7.2.0/bio/vep/plugins"


rule vep_annotate_variants:
    input:
        calls="results/{caller}/call/{sample}.bcf",
        plugins="resources/vep/plugins",
        fasta=rules.get_genome.output.fasta,
        fai=rules.get_genome.output.fai,
        gff=rules.vep_prepare.output.gff,
    output:
        calls="results/{caller}/effect/{sample}_variants.vcf",
        stats="results/{caller}/effect/{sample}_variants.html",
    params:
        # available plugins: https://www.ensembl.org/info/docs/tools/vep/script/vep_plugins.html
        plugins=config["variant_calling"]["variant_effect_prediction"]["plugins"],
        extra="--everything --species custom_bacteria",
    log:
        "results/{caller}/effect/{sample}_variants.log",
    threads: 4
    wrapper:
        "v7.2.0/bio/vep/annotate"
