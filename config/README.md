## Workflow overview

This workflow is a best-practice workflow for mapping of reads to reference genomes, minimalistic and simple.
The workflow is built using [snakemake](https://snakemake.readthedocs.io/en/stable/) and consists of the following steps:

1. Download genome reference from NCBI (`ncbi tools`), or use manual input (`fasta` format)
2. Check quality of input read data (`FastQC`)
3. Trim adapters and apply quality filtering (`fastp`)
4. Determine experiment type (`rseqc`)
5. Map reads to reference genome using:
   1. Bowtie2 _or_
   2. BWA-MEM2 _or_
   3. STAR
6. Evaluate mapping quality, quantify variations
7. Collect statistics from tool output (`MultiQC`)

## Running the workflow

### Input data

The workflow requires sequencing data in `*.fastq.gz` format, and a reference genome to map to.
The sample sheet listing read input files needs to have the following layout:

| sample  | description | read1               | read2               |
| ------- | ----------- | ------------------- | ------------------- |
| sample1 | strain XY   | sample1.R1.fastq.gz | sample1.R2.fastq.gz |
| ...     | ...         | ...                 | ...                 |

### Parameters

This table lists all parameters that can be used to run the workflow.

| parameter       | type | details                        | default              |
| --------------- | ---- | ------------------------------ | -------------------- |
| **samplesheet** |      |                                |                      |
| path            | str  | path to samplesheet, mandatory | "config/samples.tsv" |
| **get_genome**  |      |                                |                      |

TODO: finalize parameters.
