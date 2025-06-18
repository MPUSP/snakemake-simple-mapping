## Workflow overview

This workflow is a best-practice workflow for mapping of reads to reference genomes, minimalistic and simple.
The workflow is built using [snakemake](https://snakemake.readthedocs.io/en/stable/) and consists of the following steps:

1. Download genome reference from NCBI (`ncbi tools`), or use manual input (`fasta`, `gff` format)
2. Check quality of input read data (`FastQC`)
3. Trim adapters and apply quality filtering (`fastp`)
4. Map reads to reference genome using:
   1. (`Bowtie2`)[http://bowtie-bio.sourceforge.net/bowtie2/manual.shtml] _or_
   2. (`BWA-MEM2`)[https://github.com/bwa-mem2/bwa-mem2] _or_
   3. (`STAR`)[https://github.com/alexdobin/STAR] (not implemented yet)
5. Determine experiment type, get mapping stats (`rseqc`)
6. Generate `bigwig` or `bedgaph` coverage profiles (`deeptools`)
7. Quantify variations and SNPs (`bcftools`)
8. Collect statistics from tool output (`MultiQC`)

## Running the workflow

### Input data

The workflow requires sequencing data in `*.fastq.gz` format, and a reference genome to map to.
The sample sheet listing read input files needs to have the following layout:

| sample  | description | read1               | read2               |
| ------- | ----------- | ------------------- | ------------------- |
| sample1 | strain XY   | sample1_R1.fastq.gz | sample1_R2.fastq.gz |
| ...     | ...         | ...                 | ...                 |

### Parameters

This table lists all parameters that can be used to run the workflow.

| parameter                      | type    | details                                                  | default |
| ------------------------------ | ------- | -------------------------------------------------------- | ------- |
| **samplesheet**                | string  | path to the sample sheet in tsv format                   |         |
| **get_genome**                 | object  | genome retrieval options                                 |         |
| database                       | string  | database to use for genome retrieval, 'ncbi' or 'manual' |         |
| assembly                       | string  | assembly version to use for genome retrieval             |         |
| fasta                          | string  | path to a custom FASTA file (optional)                   |         |
| gff                            | string  | path to a custom GFF file (optional)                     |         |
| gff_source_type                | array   | mapping of GFF source types to feature types             |         |
| **fastp**                      | object  | Fastp options                                            |         |
| extra                          | string  | additional arguments to Fastp                            |         |
| **mapping**                    | object  | mapping options                                          |         |
| tool                           | string  | mapping tool to use, one of 'bowtie2', 'bwa_mem2'        |         |
| bowtie2                        | object  | Bowtie2 options                                          |         |
| bowtie2.index                  | string  | additional arguments to bowtie build                     |         |
| bowtie2.extra                  | string  | additional arguments to bowtie align                     |         |
| bwa_mem2                       | object  | BWA-MEM2 options                                         |         |
| bwa_mem2.extra                 | string  | additional arguments to bwa-mem2                         |         |
| bwa_mem2.sort                  | string  | sorting tool to use, e.g. 'samtools'                     |         |
| bwa_mem2.sort_order            | string  | sorting order to use                                     |         |
| bwa_mem2.sort_extra            | string  | additional arguments to the sorting tool                 |         |
| samtools_sort                  | object  | Samtools sort options                                    |         |
| samtools_sort.extra            | string  | additional arguments to Samtools sort                    |         |
| samtools_index                 | object  | Samtools index options                                   |         |
| samtools_index.extra           | string  | additional arguments to Samtools index                   |         |
| **mapping_stats**              | object  | mapping statistics options                               |         |
| gffread                        | object  | GFFread options                                          |         |
| gffread.extra                  | string  | additional arguments to GFFread                          |         |
| rseqc_infer_experiment         | object  | RSeQC infer_experiment.py options                        |         |
| rseqc_infer_experiment.extra   | string  | additional arguments to RSeQC infer_experiment.py        |         |
| rseqc_bam_stat                 | object  | RSeQC bam_stat.py options                                |         |
| rseqc_bam_stat.extra           | string  | additional arguments to RSeQC bam_stat.py                |         |
| deeptools_coverage             | object  | DeepTools bamCoverage options                            |         |
| deeptools_coverage.genome_size | integer | genome size in base pairs                                |         |
| deeptools_coverage.extra       | string  | additional arguments to DeepTools bamCoverage            |         |
| **variant_calling**            | object  | variant calling options                                  |         |
| bcftools_pileup                | object  | BCFtools pileup options                                  |         |
| bcftools_pileup.uncompressed   | boolean | whether to output uncompressed BCF files                 |         |
| bcftools_pileup.extra          | string  | additional arguments to BCFtools pileup                  |         |
| bcftools_call                  | object  | BCFtools call options                                    |         |
| bcftools_call.uncompressed     | boolean | whether to output uncompressed VCF files                 |         |
| bcftools_call.caller           | string  | use '-c' for consensus or '-m' for multiallelic          |         |
| bcftools_call.extra            | string  | additional arguments to BCFtools call                    |         |
