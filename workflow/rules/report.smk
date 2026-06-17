rule bcftools_bcf_and_index:
    input:
        "results/{caller}/effect/{sample}{ext}",
    output:
        "results/{caller}/effect/{sample}{ext}.gz",
        "results/{caller}/effect/{sample}{ext}.gz.csi",
    log:
        "results/{caller}/effect/{sample}{ext}.gz.log",
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
        "results/{caller}/consensus/variants.vcf",
    log:
        "results/{caller}/consensus/variants.log",
    conda:
        "../envs/bcftools.yml"
    params:
        extra="-c none",
        vcf_count=config["report"].get("minimum_variant_count", 2),
    message:
        "intersect variant calls from different callers"
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
    log:
        "results/report/{caller}_report.log",
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
        html="results/report/{caller}_report.html",
    output:
        pdf="results/report/{caller}_report.pdf",
    log:
        path="results/report/{caller}_report_pdf.log",
    conda:
        "../envs/report_pdf.yml"
    message:
        "converting HTML to PDF"
    shell:
        "weasyprint -v {input.html} {output.pdf} &> {log.path}"
