__author__ = "Michael Jahn"
__copyright__ = "Copyright 2025, Michael Jahn"
__email__ = "jahn@mpusp.mpg.de"
__license__ = "MIT"
__annotations__ = "script to convert NCBI GFF files to VEP-friendly format"


import sys
from snakemake.shell import shell


# default inputs/outputs
sys.stderr = open(snakemake.log[0], "w", buffering=1)
input_gff = snakemake.input.get("gff")
output_gff = snakemake.output.get("gff")
output_gff_gz = snakemake.output.get("gff_gz")
convert_gff = snakemake.params.get("convert_gff", False)


def parse_attributes(attr_str):
    attrs = {}
    for part in attr_str.strip().split(";"):
        if "=" in part:
            k, v = part.split("=", 1)
            attrs[k] = v
    return attrs


def format_attributes(attrs):
    return ";".join(f"{k}={v}" for k, v in attrs.items())


# change gene/CDS annotation to gene/transcript/exon
result = []
with open(input_gff) as gff:
    for line in gff.readlines():
        if not line.startswith("#"):
            cols = line.rstrip("\n").split("\t")
            if len(cols) < 9:
                continue
            if (
                cols[2] in ["gene", "pseudogene", "exon", "transcript"]
            ) or not convert_gff:
                result += [line.rstrip("\n")]
            elif cols[2] == "CDS":
                attrs = parse_attributes(cols[8])
                gene_id = attrs.get("Parent")
                cds_id = attrs.get("ID", "cds-" + gene_id)
                # create transcript feature
                transcript_id = f"transcript-{cds_id.lstrip("cds-")}"
                transcript_attrs = {
                    "ID": transcript_id,
                    "Parent": gene_id,
                    "biotype": "protein_coding",
                }
                result += [
                    "\t".join(
                        cols[:2]
                        + ["transcript"]
                        + cols[3:8]
                        + [format_attributes(transcript_attrs)]
                    )
                ]
                # create exon feature
                exon_id = f"exon-{cds_id.lstrip("cds-")}"
                exon_attrs = {"ID": exon_id, "Parent": transcript_id}
                result += [
                    "\t".join(
                        cols[:2]
                        + ["exon"]
                        + cols[3:8]
                        + [format_attributes(exon_attrs)]
                    )
                ]
            else:
                sys.stderr.write(
                    f"Unsupported feature type: {cols[2]} found in line: {line[:100] + '...'}\n"
                )

# write output to file
with open(output_gff, "w") as out_gff:
    out_gff.write("\n".join(result) + "\n")
sys.stderr.write(f"Converted {input_gff} from NCBI GFF to VEP compatible format\n")

# sort, gzip, and index according to recommendations from
# https://www.ensembl.org/info/docs/tools/vep/script/vep_cache.html#gff
shell(
    "cat {output_gff} | sort -k1,1 -k4,4n -k5,5n -t$'\t' | bgzip -c > {output_gff_gz};"
    "tabix -p gff {output_gff_gz}"
)
sys.stderr.write(f"Exported sorted, gzipped, and indexed GFF '{output_gff_gz}'.\n")
