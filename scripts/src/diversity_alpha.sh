#!/bin/bash

set -e

# Add logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "Starting diversity script"

data_dir="../data"

log "Starting rarefaction..."

! qiime diversity alpha-rarefaction \
    --i-table $data_dir/raw/dada2_table.qza \
    --p-max-depth 35566 \
    --m-metadata-file $data_dir/raw/metadata_per_sample.tsv \
    --o-visualization $data_dir/processed/alpha_rarefaction.qzv

log "Rarefaction completed"
log "Starting bootstrapping..."

# Run BOOTs for kmer-diversity on collapsed and uncollapsed table

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
    --output-dir $data_dir/raw/boots_kmer_diversity_collapsed

! qiime boots kmer-diversity \
    --i-table $data_dir/raw/dada2_table.qza \
    --i-sequences $data_dir/raw/dada2_rep_set.qza \
    --m-metadata-file $data_dir/raw/metadata.tsv \
    --p-sampling-depth 9000 \
    --p-n 10 \
    --p-kmer-size 12 \
    --p-replacement \
    --p-alpha-average-method median \
    --p-beta-average-method medoid \
    --output-dir $data_dir/raw/boots_kmer_diversity

# Run BOOTs for normal diversity metrics on collapsed and uncollapsed table
# We are mainly interested in shannon entropy here, which is why we do not provide a phylogenetic tree

qiime boots core-metrics \
  --i-table $data_dir/raw/table_collapsed.qza \
  --m-metadata-file $data_dir/raw/metadata_collapsed.tsv \
  --p-sampling-depth 9000 \
  --p-n 100 \
  --p-replacement \
  --output-dir $data_dir/raw/boots_core_metrics_collapsed

qiime boots core-metrics \
  --i-table $data_dir/raw/dada2_table.qza \
  --m-metadata-file $data_dir/raw/metadata.tsv \
  --p-sampling-depth 9000 \
  --p-n 100 \
  --p-replacement \
  --output-dir $data_dir/raw/boots_core_metrics

log "Bootstrapping completed"

log "Generating alpha-significance and alpha-correlation ..."

qiime diversity alpha-group-significance \
  --i-alpha-diversity $data_dir/raw/boots_kmer_diversity_collapsed/alpha_diversities/shannon.qza \
  --m-metadata-file $data_dir/raw/metadata_collapsed_withtypes.tsv \
  --o-visualization $data_dir/processed/shannon_kmer_significance.qzv

qiime diversity alpha-correlation \
  --i-alpha-diversity $data_dir/raw/boots_kmer_diversity_collapsed/alpha_diversities/shannon.qza \
  --m-metadata-file $data_dir/raw/metadata_collapsed_withtypes.tsv \
  --o-visualization $data_dir/processed/shannon_kmer_correlation.qzv

# Generating significance and correlation for shannon diversity from collapsed table
qiime diversity alpha-group-significance \
  --i-alpha-diversity $data_dir/raw/boots_core_metrics_collapsed/alpha_diversities/shannon.qza \
  --m-metadata-file $data_dir/raw/metadata_withtypes.tsv \
  --o-visualization $data_dir/processed/shannon_core_significance_collapsed.qzv

qiime diversity alpha-correlation \
  --i-alpha-diversity $data_dir/raw/boots_core_metrics_collapsed/alpha_diversities/shannon.qza \
  --m-metadata-file $data_dir/raw/metadata_withtypes.tsv \
  --o-visualization $data_dir/processed/shannon_core_correlation_collapsed.qzv

# Once again for core metrics from uncollapsed data
qiime diversity alpha-group-significance \
  --i-alpha-diversity $data_dir/raw/boots_core_metrics/alpha_diversities/shannon.qza \
  --m-metadata-file $data_dir/raw/metadata_withtypes.tsv \
  --o-visualization $data_dir/processed/shannon_core_significance.qzv

qiime diversity alpha-correlation \
  --i-alpha-diversity $data_dir/raw/boots_core_metrics/alpha_diversities/shannon.qza \
  --m-metadata-file $data_dir/raw/metadata_withtypes.tsv \
  --o-visualization $data_dir/processed/shannon_core_correlation.qzv

log "Generating alpha-significance and alpha-correlation ..."
 
log "Diversity script completed successfully!"

