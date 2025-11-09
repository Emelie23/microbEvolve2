#!/bin/bash

set -e

# Add logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "Starting UMAP script"

input_dir="$HOME/microbEvolve2/data/raw/boots_kmer_diversity/distance_matrices"
data_dir="$HOME/microbEvolve2/data"

# Check if required input directory exists
if [[ ! -d "$input_dir" ]]; then
    log "ERROR: Required input directory not found: "$input_dir""
    log "Please ensure the diversity step has been completed successfully."
    exit 1
fi

log "Input directory verified: "$input_dir""

log "Starting UMAP computation for bray-curtis and jaccard"

qiime diversity umap \
    --i-distance-matrix "$input_dir/braycurtis.qza" \
    --p-number-of-dimensions 3 \
    --p-n-neighbors 15 \
    --p-min-dist 0.4 \
    --o-umap "$data_dir/raw/umap_braycurtis.qza" \
    --p-random-state 10

qiime diversity umap \
    --i-distance-matrix "$input_dir/jaccard.qza" \
    --p-number-of-dimensions 3 \
    --p-n-neighbors 15 \
    --p-min-dist 0.4 \
    --o-umap "$data_dir/raw/umap_jaccard.qza" \
    --p-random-state 10

log "UMAP computation completed"

log "Creating visualization for UMAP..."

qiime emperor plot \
  --i-pcoa "$data_dir/raw/umap_braycurtis.qza" \
  --m-metadata-file "$data_dir/raw/metadata.tsv" \
  --o-visualization "$data_dir/processed/umap_braycurtis.qzv"

qiime emperor plot \
  --i-pcoa "$data_dir/raw/umap_jaccard.qza" \
  --m-metadata-file "$data_dir/raw/metadata.tsv" \
  --o-visualization "$data_dir/processed/umap_jaccard.qzv"

log "UMAP visualization completed successfully!"

log "UMAP script completed successfully!"
