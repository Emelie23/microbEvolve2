#!/bin/bash

set -e

# Add logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "Starting taxonomy classification script"

data_dir="../data"

# Ensure output directories exist
mkdir -p "$data_dir/raw"
mkdir -p "$data_dir/processed"

# Check if required input file exists
if [[ ! -f "$data_dir/raw/dada2_rep_set.qza" ]]; then
    log "ERROR: Required input file not found: $data_dir/raw/dada2_rep_set.qza"
    log "Please ensure the denoising step has been completed successfully."
    exit 1
fi

log "Input file verified: $data_dir/raw/dada2_rep_set.qza"

# Check if classifier files exist
missing_classifiers=false

log "Downloading weighted classifier for human stool samples..."
wget -O "$data_dir/raw/silva-138-99-515-806-nb-classifier-weighted-stool.qza" \
    https://www.arb-silva.de/fileadmin/silva_databases/current/QIIME2/2025.7/SSU/V4-515f-806r/weighted/human-stool/SILVA138.2_SSURef_NR99_weighted_classifier_V4-515f-806r_human-stool.qza
log "Weighted classifier downloaded successfully"

if [[ ! -f "$data_dir/raw/silva-138-99-515-806-nb-classifier-weighted-stool.qza" ]]; then
    log "WARNING: Weighted classifier not found: $data_dir/raw/silva-138-99-515-806-nb-classifier-weighted-stool.qza"
    missing_classifiers="true"
fi

log "Classifier file verified"

# First we will get download the reference database
# Version 138.2 is the latest version and we want small subunit (SSU) data.
# We also choose the filtered sequence dataset (99 NR)

# We will try two methods for classifying our data:
# 1. Use the pretrained classifier from SILVA for the V4 region without weights
# 2. The pretrained classifier with integrated weights based on human stool samples (reference paper: https://microbiomejournal.biomedcentral.com/articles/10.1186/s40168-018-0470-z)

log "Starting taxonomic classification with weighted classifier..."

qiime feature-classifier classify-sklearn \
    --i-classifier $data_dir/raw/silva-138-99-515-806-nb-classifier-weighted-stool.qza \
    --i-reads $data_dir/raw/dada2_rep_set.qza \
    --p-n-jobs 0 \
    --p-reads-per-batch 2000 \
    --verbose \
    --o-classification $data_dir/raw/taxonomy_weighted_stool.qza

log "Weighted taxonomic classification completed"
log "Creating visualization for weighted taxonomy results..."

qiime metadata tabulate \
    --m-input-file $data_dir/raw/taxonomy_weighted_stool.qza \
    --o-visualization $data_dir/processed/taxonomy_weighted_stool.qzv
log "Weighted taxonomy visualization created"

log "Creating taxa bar plot for weighted taxonomy results..."
qiime taxa barplot \
    --i-table $data_dir/raw/dada2_table.qza \
    --i-taxonomy $data_dir/raw/taxonomy_weighted_stool.qza \
    --m-metadata-file $data_dir/raw/metadata_per_sample.tsv \
    --o-visualization $data_dir/processed/taxa-bar-plots_weighted.qzv
log "Taxa bar plot for weighted taxonomy results created"

log "Taxonomy classification script completed successfully!"
