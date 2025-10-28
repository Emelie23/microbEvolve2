#!/bin/bash

set -e

# Add logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "Starting taxonomy classification script"

data_dir="$HOME/microbEvolve2/data"

# Check if required input file exists
if [[ ! -f "$data_dir/raw/dada2_rep_set.qza" ]]; then
    log "ERROR: Required input file not found: $data_dir/raw/dada2_rep_set.qza"
    log "Please ensure the denoising step has been completed successfully."
    exit 1
fi

log "Input file verified: $data_dir/raw/dada2_rep_set.qza"

# Check if classifier files exist
missing_classifiers=false

if [[ ! -f "$data_dir/raw/silva-138-99-515-806-nb-classifier-unweighted.qza" ]]; then
    log "WARNING: Unweighted classifier not found: $data_dir/raw/silva-138-99-515-806-nb-classifier-unweighted.qza"
    missing_classifiers=true
fi

if [[ ! -f "$data_dir/raw/silva-138-99-515-806-nb-classifier-weighted-stool.qza" ]]; then
    log "WARNING: Weighted classifier not found: $data_dir/raw/silva-138-99-515-806-nb-classifier-weighted-stool.qza"
    missing_classifiers=true
fi

if [[ "$missing_classifiers" == "true" ]]; then
    log "ERROR: One or more classifier files are missing."
    log "Please download the classifiers first by running:"
    log "  bash $HOME/microbEvolve2/scripts/taxonomy_dowload_classifier.sh"
    exit 1
fi

log "All classifier files verified"

# Ensure output directories exist
mkdir -p "$data_dir/raw"
mkdir -p "$data_dir/processed"

# First we will get download the reference database
# Version 138.2 is the latest version and we want small subunit (SSU) data.
# We also choose the filtereds sequence dataset (99 NR)

# We will try two methods for classifying our data:
# 1. Use the pretrained classifier from SILVA for the V4 region without weights
# 2. The pretrained classifier with integrated weights based on human stool samples (reference paper: https://microbiomejournal.biomedcentral.com/articles/10.1186/s40168-018-0470-z)

log "Starting taxonomic classification with weighted classifier..."

qiime feature-classifier classify-sklearn \
    --i-classifier "$data_dir/raw/silva-138-99-515-806-nb-classifier-weighted-stool.qza" \
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

log "Starting taxonomic classification with unweighted classifier..."

qiime feature-classifier classify-sklearn \
    --i-classifier "$data_dir/raw/silva-138-99-515-806-nb-classifier-unweighted.qza" \
    --i-reads $data_dir/raw/dada2_rep_set.qza \
    --p-n-jobs 0 \
    --p-reads-per-batch 2000 \
    --o-classification $data_dir/raw/taxonomy_unweighted.qza

log "Unweighted taxonomic classification completed"
log "Creating visualization for unweighted taxonomy results..."

qiime metadata tabulate \
    --m-input-file $data_dir/raw/taxonomy_unweighted.qza \
    --o-visualization $data_dir/processed/taxonomy_unweighted.qzv

log "Unweighted taxonomy visualization created"

log "Creating taxa bar plot for unweighted taxonomy results..."
qiime taxa barplot \
    --i-table $data_dir/raw/dada2_table.qza \
    --i-taxonomy $data_dir/raw/taxonomy_unweighted.qza \
    --m-metadata-file $data_dir/raw/metadata_per_sample.tsv \
    --o-visualization $data_dir/processed/taxa-bar-plots_unweighted.qzv
log "Taxa bar plot for unweighted taxonomy results created"

log "Taxonomy classification script completed successfully!"
