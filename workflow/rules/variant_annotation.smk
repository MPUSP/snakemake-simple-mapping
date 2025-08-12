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
        extra=config["variant_calling"]["effect_prediction"]["extra"],
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
        db_dir=directory("results/snpeff/custom_db"),
    params:
        genome_name="custom_genome",
        extra="-noCheckCds -noCheckProtein",
    log:
        "results/snpeff/build_db.log",
    conda:
        "../envs/snpeff.yml"
    shell:
        """
        mkdir -p {output.db_dir}/{params.genome_name}
        config="$(realpath $(whereis snpEff | awk '{{print $2}}')).config"
        today="$(date +%Y-%m-%d)"
        cp {input.fasta} {output.db_dir}/{params.genome_name}/sequences.fa
        cp {input.gff} {output.db_dir}/{params.genome_name}/genes.gff
        cp ${{config}} {output.db_dir}/snpeff.config
        echo -e "\n# automatic entry by workflow: snakemake-simple-mapping" >> {output.db_dir}/snpeff.config
        echo -e "{params.genome_name}.genome : {params.genome_name}" >> {output.db_dir}/snpeff.config
        echo -e "{params.genome_name}.retrieval_date : ${{today}}\n" >> {output.db_dir}/snpeff.config
        snpEff build {params.extra} -c {output.db_dir}/snpeff.config -gff3 -dataDir $(realpath {output.db_dir}) {params.genome_name} > {log} 2>&1
        """



# rule snpeff:
#     input:
#         calls="results/{caller}/call/{sample}.bcf",
#     output:
#         calls="snpeff/{sample}.vcf",  # annotated calls (vcf, bcf, or vcf.gz)
#         stats="snpeff/{sample}.html",  # summary statistics (in HTML), optional
#         csvstats="snpeff/{sample}.csv",  # summary statistics in CSV, optional
#     log:
#         "logs/snpeff/{sample}.log",
#     resources:
#         java_opts="-XX:ParallelGCThreads=10",
#         mem_mb=4096,
#     wrapper:
#         "v7.2.0/bio/snpeff/annotate"
