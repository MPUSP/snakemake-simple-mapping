## Workflow overview

This workflow is a best-practice workflow for mapping of reads to reference genomes, minimalistic and simple.

It will attempt to map reads to the reference using one of the included mappers, report read and experiment statistics, create coverage profiles, quantify variants (such as SNPs) using two different tools, and predict the effect of these variants.
All of this is performed with minimal input and without lookups to external databases (e.g. for variant effects), which makes the workflow ideal for bacteria and other low-complexity non-model organisms.

The workflow is built using [snakemake](https://snakemake.readthedocs.io/en/stable/) and consists of the following steps:

1. Download genome reference from NCBI (`ncbi tools`), or use manual input (`fasta`, `gff` format)
2. Check quality of input read data (`FastQC`)
3. Trim adapters and apply quality filtering (`fastp`)
4. Map reads to reference genome using:
   1. (`Bowtie2`)[http://bowtie-bio.sourceforge.net/bowtie2/manual.shtml] _or_
   2. (`BWA-MEM2`)[https://github.com/bwa-mem2/bwa-mem2] _or_
   3. (`STAR`)[https://github.com/alexdobin/STAR]
   4. (`minimap2`)[https://github.com/lh3/minimap2]
5. Determine experiment type, get mapping stats (`rseqc`)
6. Generate `bigwig` or `bedgaph` coverage profiles (`deeptools`)
7. Quantify variations and SNPs (`bcftools`, `freebayes`)
8. Predict effect of variants such as premature stop codons (`VEP` or `SnpEff`)
9. Create consensus of variants and create a visual report (`R markdown`)
10. Collect statistics from tool output (`MultiQC`)

## Running the workflow

### Input data

The workflow requires sequencing data in `*.fastq.gz` format, and a reference genome to map to.
The sample sheet listing read input files needs to have the following layout:

| sample  | description | read1               | read2               |
| ------- | ----------- | ------------------- | ------------------- |
| sample1 | strain XY   | sample1_R1.fastq.gz | sample1_R2.fastq.gz |
| ...     | ...         | ...                 | ...                 |
