#!/bin/bash

#Actvate conda environment before running the shell script
#I installed openpyxl into microbEvolve environment

#Create data directory variable
data_dir="$HOME/microbEvolve2/data"

#Create directories microbEvolve and Data to store the data into $HOME
mkdir -p "$data_dir/raw"
mkdir -p "$data_dir/processed"

#Import data
wget -O "$data_dir/raw/demux_paired_end.qza" \
    "https://polybox.ethz.ch/index.php/s/zi5ZBrBwcn7SYof/download/demux-paired-end.qza"

wget -O "$data_dir/raw/metadata.xlsx" \
    "https://polybox.ethz.ch/index.php/s/YQQggAqcQCApJmQ/download"

# Export metadata into single .tsv files
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