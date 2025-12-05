#!/bin/bash

set -e

# Add logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "Starting Differential Abundance script"

data_dir_raw="../data/raw"
data_dir_processed="../data/processed"

log "Filter feature table for minimal frequency and abundance in samples"

# only retain features with minimal frequency of 1 that are present in min 1 samples
qiime feature-table filter-features \
    --i-table $data_dir_raw/table_collapsed.qza \
    --p-min-frequency 1 \
    --p-min-samples 1 \
    --o-filtered-table $data_dir_raw/table_collapsed_abund.qza

log "Feature table filtered successfully"

log "Collapse taxa to genus level and merge with feature table"

# collapse taxa to genus level and merge with feature table
qiime taxa collapse \
    --i-table $data_dir_raw/table_collapsed_abund.qza \
    --i-taxonomy $data_dir_raw/taxonomy_weighted_stool.qza \
    --p-level 6 \
    --o-collapsed-table $data_dir_raw/table_collapsed_abund_l6.qza

log "Taxa collapsed and merged to feature table"

log "Starting ANCOM-BC"

# Run ANCOM-BC
qiime composition ancombc2 \
    --i-table $data_dir_raw/table_collapsed_abund_l6.qza \
    --m-metadata-file $data_dir_raw/metadata_collapsed.tsv \
    --p-fixed-effects-formula "timepoint" \
    --p-random-effects-formula "(1| infant_id)"\
    --p-reference-levels "timepoint::2 months" \
    --p-p-adjust-method "BH" \
    --o-ancombc2-output $data_dir_raw/ancombc_timepoint_differentials.qza

mkdir -p $data_dir_raw/ancombc_timepoint_differentials

qiime tools export \
    --input-path $data_dir_raw/ancombc_timepoint_differentials.qza \
    --output-path $data_dir_raw/ancombc_timepoint_differentials

# Generate a barplot of differentially abundant ASVs between timpoints
qiime composition ancombc2-visualizer \
    --i-data $data_dir_raw/ancombc_timepoint_differentials.qza \
    --o-visualization $data_dir_processed/ancombc_timepoints_da_barplot.qzv

# Generate a table of these same values for all ASVs
qiime composition tabulate \
    --i-data $data_dir_raw/ancombc_timepoint_differentials.qza \
    --o-visualization $data_dir_processed/ancombc_timepoint_results.qzv

log "ANCOM-BC completed successfully"

log "Differential Abundance script completed successfully!"
