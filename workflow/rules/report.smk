rule bcftools_bcf_and_index:
    input:
        "results/{caller}/effect/{sample}{ext}",
    output:
        "results/{caller}/effect/{sample}{ext}.gz",
        "results/{caller}/effect/{sample}{ext}.gz.csi",
    log:
        "results/{caller}/effect/{sample}{ext}.gz.log",
    message:
        "bgzip and index variant calls"
    params:
        extra="--write-index",
    wrapper:
        "v7.2.0/bio/bcftools/view"


rule bcftools_intersection:
    input:
        get_variants,
    output:
        "results/{caller}/consensus/variants.vcf",
    log:
        "results/{caller}/consensus/variants.log",
    message:
        "intersect variant calls from different callers"
    params:
        extra="-c none",
        vcf_count=config["report"].get("minimum_variant_count", 2),
    conda:
        "../envs/bcftools.yml"
    shell:
        "bcftools isec -n+{params.vcf_count} {params.extra} -o {output} {input}"


rule report_html:
    input:
        fasta=rules.get_genome.output.fasta,
        gff=rules.get_genome.output.gff,
        variants=get_variants,
        consensus="results/{caller}/consensus/variants.vcf",
    output:
        html="results/report/{caller}_report.html",
    conda:
        "../envs/report_html.yml"
    message:
        "rendering R markdown notebook"
    params:
        vcf_count=config["report"].get("minimum_variant_count", 2),
    log:
        "results/report/{caller}_report.log",
    script:
        "../notebooks/report.Rmd"


rule report_pdf:
    input:
        html="results/report/{caller}_report.html",
    output:
        pdf="results/report/{caller}_report.pdf",
    conda:
        "../envs/report_pdf.yml"
    message:
        "converting HTML to PDF"
    log:
        path="results/report/{caller}_report_pdf.log",
    shell:
        "weasyprint -v {input.html} {output.pdf} &> {log.path}"
