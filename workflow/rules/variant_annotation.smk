rule vep_prepare:
    input:
        gff=rules.get_genome.output.gff,
    output:
        gff="results/get_genome/genome_vep.gff",
        gff_gz="results/get_genome/genome.gff.gz",
        index="results/get_genome/genome.gff.gz.tbi",
    params:
        convert_gff=config["variant_calling"]["effect_prediction"]["convert_gff"],
    conda:
        "../envs/vep.yml"
    log:
        "results/get_genome/tabix.log",
    threads: 1
    script:
        "../scripts/convert_gff.py"


rule vep_plugins:
    output:
        directory("resources/vep/plugins"),
    params:
        release=100,
    log:
        "results/vep/plugins.log",
    wrapper:
        "v7.2.0/bio/vep/plugins"


rule vep_annotate_variants:
    input:
        calls="results/{caller}/call/{sample}.bcf",
        plugins="resources/vep/plugins",
        fasta=rules.get_genome.output.fasta,
        fai=rules.get_genome.output.fai,
        gff=rules.vep_prepare.output.gff_gz,
    output:
        calls="results/{caller}/effect/{sample}_vep.vcf",
        stats="results/{caller}/effect/{sample}_vep.html",
    params:
        # available plugins: https://www.ensembl.org/info/docs/tools/vep/script/vep_plugins.html
        plugins=config["variant_calling"]["effect_prediction"]["plugins"],
        extra="--everything --species custom_bacteria --distance 0",
    log:
        "results/{caller}/effect/{sample}_vep.log",
    threads: 4
    wrapper:
        "v7.2.0/bio/vep/annotate"
