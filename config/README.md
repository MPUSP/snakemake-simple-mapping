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
7. Quantify variations and SNPs (`bcftools`, `freebayes`)
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

| parameter                | type    | details                                                  | default           |
| ------------------------ | ------- | -------------------------------------------------------- | ----------------- |
| **samplesheet**          | string  | path to the sample sheet in tsv format                   |                   |
| **get_genome**           |         |                                                          |                   |
| database                 | string  | database to use for genome retrieval, 'ncbi' or 'manual' | `ncbi`            |
| assembly                 | string  | Refseq ID to use for genome retrieval                    | `GCF_000307535.1` |
| fasta                    | string  | path to a custom FASTA file (optional)                   |                   |
| gff                      | string  | path to a custom GFF file (optional)                     |                   |
| gff_source_type          | array   | mapping of GFF source types to feature types             |                   |
| **fastp**                |         |                                                          |                   |
| extra                    | string  | additional arguments to Fastp                            |                   |
| **mapping**              |         |                                                          |                   |
| tool                     | string  | mapping tool to use, one of 'bowtie2', 'bwa_mem2'        | `bwa_mem2`        |
| _bowtie2_                |         |                                                          |                   |
| index                    | string  | additional arguments to bowtie build                     |                   |
| extra                    | string  | additional arguments to bowtie align                     |                   |
| _bwa_mem2_               |         |                                                          |                   |
| extra                    | string  | additional arguments to bwa-mem2                         |                   |
| sort                     | string  | sorting tool to use                                      | `samtools`        |
| sort_order               | string  | sorting order to use                                     | `coordinate`      |
| sort_extra               | string  | additional arguments to the sorting tool                 |                   |
| _samtools_sort_          |         |                                                          |                   |
| extra                    | string  | additional arguments to Samtools sort                    | `-m 4G`           |
| index                    | object  | Samtools index options                                   |                   |
| extra                    | string  | additional arguments to Samtools index                   |                   |
| **mapping_stats**        |         |                                                          |                   |
| _gffread_                |         |                                                          |                   |
| extra                    | string  | additional arguments to GFFread                          |                   |
| _rseqc_infer_experiment_ |         |                                                          |                   |
| extra                    | string  | additional arguments to RSeQC infer_experiment           |                   |
| _rseqc_bam_stat_         |         |                                                          |                   |
| extra                    | string  | additional arguments to RSeQC bam_stat                   |                   |
| _deeptools_coverage_     |         |                                                          |                   |
| genome_size              | integer | genome size in base pairs                                | `1000`            |
| extra                    | string  | additional arguments to DeepTools bamCoverage            |                   |
| **variant_calling**      |         |                                                          |                   |
| _bcftools_pileup_        |         |                                                          |                   |
| uncompressed             | boolean | whether to output uncompressed BCF files                 | `False`           |
| extra                    | string  | additional arguments to BCFtools pileup                  |                   |
| _bcftools_call_          |         |                                                          |                   |
| uncompressed             | boolean | whether to output uncompressed VCF files                 | `False`           |
| caller                   | string  | use '-c' for consensus or '-m' for multiallelic          | `-c`              |
| extra                    | string  | additional arguments to BCFtools view                    |                   |
| _bcftools_view_          |         |                                                          |                   |
| extra                    | string  | additional arguments to BCFtools call                    |                   |
| _bcftools_filter_        |         |                                                          |                   |
| filter                   | string  | expression by which to filter BCF/VCF result             | `-e 'ALT=\".\"'`  |
| extra                    | string  | additional arguments to BCFtools filter                  |                   |
| _freebayes_              |         |                                                          |                   |
| extra                    | string  | additional arguments to Freebayes call                   |                   |
