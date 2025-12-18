#!/bin/bash

set -e

# Add logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "Starting longitudinal script"

data_dir="../data"


qiime longitudinal volatility \
  --m-metadata-file $data_dir/raw/numeric_metadata.tsv \
  --m-metadata-file $data_dir/raw/boots_kmer_diversity/alpha_diversities/shannon.qza \
  --p-state-column timepoint \
  --p-individual-id-column infant_id \
  --p-default-metric shannon_entropy \
  --o-visualization $data_dir/processed/shannon_volatility.qzv
  
  
log "volatility completed"

log "Starting linear-mixed-effects..."

qiime longitudinal linear-mixed-effects \
  --m-metadata-file $data_dir/raw/numeric_metadata.tsv \
  --m-metadata-file $data_dir/raw/boots_kmer_diversity/alpha_diversities/shannon.qza \
  --p-metric shannon_entropy \
  --p-individual-id-column infant_id \
  --p-state-column timepoint \
  --p-formula "shannon_entropy ~ timepoint + age_days" \
  --o-visualization $data_dir/processed/shannon_lme.qzv
  
  
log "linear-mixed-effects completed"

log "Starting pairwise differences..."


# Pairwise Differences
qiime longitudinal pairwise-differences \
  --m-metadata-file $data_dir/raw/numeric_metadata.tsv \
  --m-metadata-file $data_dir/raw/boots_kmer_diversity/alpha_diversities/shannon.qza \
  --p-metric shannon_entropy \
  --p-individual-id-column infant_id \
  --p-state-column timepoint \
  --p-state-1 2 \
  --p-state-2 6 \
  --p-replicate-handling random \
  --p-parametric \
  --o-visualization $data_dir/processed/shannon_pairwise_2_6.qzv

qiime longitudinal pairwise-differences \
  --m-metadata-file $data_dir/raw/numeric_metadata.tsv \
  --m-metadata-file $data_dir/raw/boots_kmer_diversity/alpha_diversities/shannon.qza \
  --p-metric shannon_entropy \
  --p-individual-id-column infant_id \
  --p-state-column timepoint \
  --p-state-1 2 \
  --p-state-2 4 \
  --p-replicate-handling random \
  --p-parametric \
  --o-visualization $data_dir/processed/shannon_pairwise_2_4.qzv
  
  
qiime longitudinal pairwise-differences \
  --m-metadata-file $data_dir/raw/numeric_metadata.tsv \
  --m-metadata-file $data_dir/raw/boots_kmer_diversity/alpha_diversities/shannon.qza \
  --p-metric shannon_entropy \
  --p-individual-id-column infant_id \
  --p-state-column timepoint \
  --p-state-1 4 \
  --p-state-2 6 \
  --p-replicate-handling random \
  --p-parametric \
  --o-visualization $data_dir/processed/shannon_pairwise_4_6.qzv
  

log "pairwise differences completed"

log "longitudinal script completed successfully!"