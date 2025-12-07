#!/bin/bash

#Activate conda environment microbEvolve
#Install openpyxl into microbEvolve environment

set -e

# Add logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "Starting importing script"

#Create data directory variable
data_dir="../data"

#Create directories
mkdir -p "$data_dir/raw"
mkdir -p "$data_dir/processed"

#Import data
log "Importing 16S rRNA sequencing data..."

wget -O "$data_dir/raw/demux_paired_end.qza" \
    "https://polybox.ethz.ch/index.php/s/zi5ZBrBwcn7SYof/download/demux-paired-end.qza"

log "16S rRNA sequencing import completed and stored in $data_dir/raw/dada2_rep_set.qza"

log "Importing metadata..."

wget -O "$data_dir/raw/metadata.xlsx" \
    "https://polybox.ethz.ch/index.php/s/YQQggAqcQCApJmQ/download"

log "Metadata import completed and stored in $data_dir/raw/metadata.xlsx"

# Export metadata into single .tsv files
log "Saving metadata as single .tsv files..."
python3 <<EOF
import pandas as pd

df = pd.read_excel("$data_dir/raw/metadata.xlsx", sheet_name="DataDictionary")
df.to_csv("$data_dir/raw/metadata_dictionary.tsv", sep="\t", index=False)

df = pd.read_excel("$data_dir/raw/metadata.xlsx", sheet_name="metadata_per_sample")
df.rename(columns={"Unnamed: 0": "sampleid"}, inplace=True)
df.to_csv("$data_dir/raw/metadata_per_sample.tsv", sep="\t", index=False)

df = pd.read_excel("$data_dir/raw/metadata.xlsx", sheet_name="metadata_per_age")
df.to_csv("$data_dir/raw/metadata_per_age.tsv", sep="\t", index=False)

EOF

log "metadata_dictionary metadata_per_age and metadata_per_sample stored successfuly as single .tsv files in $data_dir/raw/"

log "Import script completed successfully!"