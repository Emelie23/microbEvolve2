#!/bin/bash

set -e

# Add logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "Starting UMAP and PCoA exporting script"

data_dir="../data/raw"

qiime tools export \
  --input-path "$data_dir/umap_braycurtis.qza" \
  --output-path "$data_dir/umap_pcoa_export/umap_braycurtis"

qiime tools export \
  --input-path "$data_dir/umap_jaccard.qza" \
  --output-path "$data_dir/umap_pcoa_export/umap_jaccard"

qiime tools export \
  --input-path "$data_dir/pcoa_braycurtis.qza" \
  --output-path "$data_dir/umap_pcoa_export/pcoa_braycurtis"

qiime tools export \
  --input-path "$data_dir/pcoa_jaccard.qza" \
  --output-path "$data_dir/umap_pcoa_export/pcoa_jaccard"

log "UMAP and PCoA script completed successfully!"
