# make QC report
# -----------------------------------------------------
rule fastqc:
    input:
        fastq="results/get_fastq/{sample}_{read}.fastq.gz",
    output:
        html="results/fastqc/{sample}_{read}_fastqc.html",
        zip="results/fastqc/{sample}_{read}_fastqc.zip",
    params:
        extra=config["qc"]["fastqc"]["extra"],
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
        get_multiqc_input,
    output:
        report="results/multiqc/multiqc_report.html",
    params:
        extra=config["qc"]["multiqc"]["extra"],
    message:
        """--- Generating MultiQC report for seq data."""
    log:
        "results/multiqc/multiqc.log",
    wrapper:
        "v6.0.0/bio/multiqc"
