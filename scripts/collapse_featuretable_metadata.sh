#!/bin/bash

set -e

# Add logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "Starting script to collapse feature table and metadata..."

data_dir="data/raw"

#create intermediate metadata file
log "Run script to create intermedia metadata file (that is needed to collapse feature table)"
python scripts/infant_time_metadata.py
log "Intermediate metadata file completed successfully"

#collapse metadata
log "Run script to collapse metadata"
python scripts/collapse_metadata.py
log "Metadata collapsed successfully"

# collapse feature table to have one representative sample per infant per timepoint - take mean of all ASVs
log "Collapse feature table to have on representative sample per infant per timepoint"

qiime feature-table group \
    --i-table $data_dir/dada2_table.qza \
    --p-axis "sample" \
    --m-metadata-file $data_dir/metadata_infant_time.tsv \
    --m-metadata-column infant_time \
    --p-mode mean-ceiling \
    --o-grouped-table $data_dir/table_collapsed.qza

log "Feature table collapsed successfully"


log "Collapse metadata to have on representative sample per infant per timepoint"