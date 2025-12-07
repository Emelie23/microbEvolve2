#!/bin/bash

set -e

# Add logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "Starting PCoA script"

input_dir="../data/raw/boots_kmer_diversity/distance_matrices"
data_dir="../data"

# Check if required input directory exists
if [[ ! -d "$input_dir" ]]; then
    log "ERROR: Required input directory not found: "$input_dir""
    log "Please ensure the diversity step has been completed successfully."
    exit 1
fi

log "Input directory verified: "$input_dir""

log "Starting PCoA computation for bray-curtis and jaccard"

qiime diversity pcoa \
  --i-distance-matrix "$input_dir/braycurtis.qza" \
  --o-pcoa "$data_dir/raw/pcoa_braycurtis.qza"

qiime diversity pcoa \
  --i-distance-matrix "$input_dir/jaccard.qza" \
  --o-pcoa "$data_dir/raw/pcoa_jaccard.qza"

log "PCoA computation completed"

log "Creating visualization for PCoA..."

qiime emperor plot \
  --i-pcoa "$data_dir/raw/pcoa_braycurtis.qza" \
  --m-metadata-file "$data_dir/raw/metadata.tsv" \
  --o-visualization "$data_dir/processed/pcoa_braycurtis.qzv"

  qiime emperor plot \
  --i-pcoa "$data_dir/raw/pcoa_jaccard.qza" \
  --m-metadata-file "$data_dir/raw/metadata.tsv" \
  --o-visualization "$data_dir/processed/pcoa_jaccard.qzv"

log "PCoA visualization completed successfully!"

log "PCoA script completed successfully!"