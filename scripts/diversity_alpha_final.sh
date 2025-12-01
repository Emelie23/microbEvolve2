#!/bin/bash

set -e

# Add logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "Starting diversity script"

data_dir="$HOME/microbEvolve2/data"

log "Starting rarefaction..."

! qiime diversity alpha-rarefaction \
    --i-table $data_dir/raw/dada2_table.qza \
    --p-max-depth 35566 \
    --m-metadata-file $data_dir/raw/metadata_per_sample.tsv \
    --o-visualization $data_dir/processed/alpha_rarefaction.qzv

log "Rarefaction completed"
log "Starting bootstrapping..."

! qiime boots kmer-diversity \
    --i-table $data_dir/raw/table_collapsed.qza \
    --i-sequences $data_dir/raw/dada2_rep_set.qza \
    --m-metadata-file $data_dir/raw/metadata_collapsed.tsv \
    --p-sampling-depth 9000 \
    --p-n 10 \
    --p-kmer-size 12 \
    --p-replacement \
    --p-alpha-average-method median \
    --p-beta-average-method medoid \
    --output-dir $data_dir/raw/boots_kmer_diversity

log "Bootstrapping completed"

log "Generating alpha-significance and alpha-correlation ..."

qiime diversity alpha-group-significance \
  --i-alpha-diversity $data_dir/raw/boots_kmer_diversity/alpha_diversities/shannon.qza \
  --m-metadata-file $data_dir/raw/metadata_collapsed.tsv \
  --o-visualization $data_dir/processed/shannon_significance.qzv

qiime diversity alpha-correlation \
  --i-alpha-diversity $data_dir/raw/boots_kmer_diversity/alpha_diversities/shannon.qza \
  --m-metadata-file $data_dir/raw/metadata_collapsed.tsv \
  --o-visualization $data_dir/processed/shannon_correlation.qzv

log "Generating alpha-significance and alpha-correlation ..."
 
log "Diversity script completed successfully!"

