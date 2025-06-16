# make QC report
# -----------------------------------------------------
rule fastqc:
    input:
        fastq="results/get_fastq/{sample}_{read}.fastq.gz",
    output:
        html="results/fastqc/{sample}_{read}_fastqc.html",
        zip="results/fastqc/{sample}_{read}_fastqc.zip",
    params:
        extra="--quiet",
    message:
        """--- Checking fastq files with FastQC."""
    log:
        "results/fastqc/{sample}.bwa.{read}.log",
    threads: 1
    wrapper:
        "v6.0.0/bio/fastqc"


# run multiQC on tool output
# -----------------------------------------------------
rule multiqc:
    input:
        expand(
            "results/fastqc/{sample}_{read}_fastqc.{ext}",
            sample=samples.index,
            read=(
                ["read1", "read2"]
                if lookup(query="index.loc[{sample}]", within=samples, cols="read2")
                else ["read1"]
            ),
            ext=["html", "zip"],
        ),
        expand(
            "results/fastp/{sample}_merged.fastq.gz",
            sample=samples.index,
        ),
    output:
        report="results/multiqc/multiqc_report.html",
    params:
        extra="--verbose --dirs",
    message:
        """--- Generating MultiQC report for seq data."""
    log:
        "results/multiqc/multiqc.log",
    wrapper:
        "v6.0.0/bio/multiqc"
