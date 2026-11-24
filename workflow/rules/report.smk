rule bcftools_bcf_and_index:
    input:
        "results/{caller}/{annotater}/{sample}{ext}",
    output:
        "results/{caller}/{annotater}/{sample}{ext}.gz",
        "results/{caller}/{annotater}/{sample}{ext}.gz.csi",
    log:
        "results/{caller}/{annotater}/{sample}{ext}.gz.log",
    params:
        extra="--write-index",
    message:
        "bgzip and index variant calls"
    wrapper:
        "v9.4.1/bio/bcftools/view"


rule bcftools_intersection:
    input:
        get_variants,
    output:
        consensus="results/{caller}/{annotater}/consensus/variants.tsv",
        consensus_index="results/{caller}/{annotater}/consensus/README.txt",
    log:
        "results/{caller}/{annotater}/consensus/variants.log",
    conda:
        "../envs/bcftools.yml"
    params:
        extra="-c none",
        vcf_count=config["report"].get("minimum_variant_count", 2),
    message:
        "intersect variant calls from different callers"
    shell:
        """
        output_dir="$(dirname {output.consensus})"
        bcftools isec -p ${{output_dir}} -n+{params.vcf_count} {params.extra} {input} >{log} 2>&1
        mv ${{output_dir}}/sites.txt {output.consensus}
        rm -rf ${{output_dir}}/0*.vcf
        """


rule report_html:
    input:
        fasta=rules.get_genome.output.fasta,
        gff=rules.get_genome.output.gff,
        variants=get_variants,
        consensus="results/{caller}/{annotater}/consensus/variants.tsv",
        consensus_index="results/{caller}/{annotater}/consensus/README.txt",
    output:
        html="results/report/{caller}/{annotater}/report.html",
    log:
        "results/report/{caller}/{annotater}/report.log",
    conda:
        "../envs/report_html.yml"
    params:
        vcf_count=config["report"].get("minimum_variant_count", 2),
    message:
        "rendering R markdown notebook"
    script:
        "../notebooks/report.Rmd"


rule report_pdf:
    input:
        html="results/report/{caller}/{annotater}/report.html",
    output:
        pdf="results/report/{caller}/{annotater}/report.pdf",
    log:
        path="results/report/{caller}/{annotater}/report_pdf.log",
    conda:
        "../envs/report_pdf.yml"
    message:
        "converting HTML to PDF"
    shell:
        "weasyprint -v {input.html} {output.pdf} &> {log.path}"
