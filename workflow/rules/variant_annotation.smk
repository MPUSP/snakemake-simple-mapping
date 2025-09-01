rule vep_prepare:
    input:
        gff=rules.get_genome.output.gff,
    output:
        gff="results/get_genome/genome_vep.gff",
        gff_gz="results/get_genome/genome.gff.gz",
        index="results/get_genome/genome.gff.gz.tbi",
    params:
        convert_gff=config["variant_annotation"]["vep"]["convert_gff"],
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
        plugins=config["variant_annotation"]["vep"]["plugins"],
        extra=config["variant_annotation"]["vep"]["extra"],
    log:
        "results/{caller}/effect/{sample}_vep.log",
    threads: 4
    wrapper:
        "v7.2.0/bio/vep/annotate"


rule snpeff_prepare:
    input:
        gff=rules.vep_prepare.output.gff,
        fasta=rules.get_genome.output.fasta,
    output:
        db=directory(f"results/snpeff/custom_db/{config["get_genome"]["assembly"]}"),
    params:
        genome_name=config["get_genome"]["assembly"],
        extra="-noCheckCds -noCheckProtein",
    log:
        "results/snpeff/build_db.log",
    conda:
        "../envs/snpeff.yml"
    shell:
        """
        mkdir -p {output.db}
        config="$(realpath $(whereis snpEff | awk '{{print $2}}')).config"
        today="$(date +%Y-%m-%d)"
        cp {input.fasta} {output.db}/sequences.fa
        cp {input.gff} {output.db}/genes.gff
        cp ${{config}} {output.db}/../snpeff.config
        echo -e "\n# automatic entry by workflow: snakemake-simple-mapping" >> {output.db}/../snpeff.config
        echo -e "{params.genome_name}.genome : {params.genome_name}" >> {output.db}/../snpeff.config
        echo -e "{params.genome_name}.retrieval_date : ${{today}}\n" >> {output.db}/../snpeff.config
        snpEff build {params.extra} -c {output.db}/../snpeff.config -gff3 -dataDir $(realpath {output.db}/../) {params.genome_name} > {log} 2>&1
        """


rule snpeff:
    input:
        calls="results/{caller}/call/{sample}.bcf",
        db=f"results/snpeff/custom_db/{config["get_genome"]["assembly"]}",
    output:
        calls="results/{caller}/effect/{sample}_snpeff.vcf",
        stats="results/{caller}/effect/{sample}_snpeff.html",
        csvstats="results/{caller}/effect/{sample}_snpeff.csv",
    params:
        extra=f"-c results/snpeff/custom_db/snpeff.config {config["variant_annotation"]["snpeff"]["extra"]}",
    log:
        "results/{caller}/effect/{sample}_snpeff.log",
    resources:
        java_opts="-XX:ParallelGCThreads=2",
        mem_mb=4096,
    wrapper:
        "v7.2.0/bio/snpeff/annotate"
