#!/bin/bash

set -e

# Add logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

log "Starting script to collapse feature table..."

data_dir="data/raw"
scripts_dir="src"

log "Collapse feature table to have on representative sample per infant per timepoint..."
# collapse feature table to have one representative sample per infant per timepoint - take mean of all ASVs (p-mode = mean-ceiling)
# use the metadata_infant_time.tsv file to group by infant_time
qiime feature-table group \
    --i-table $data_dir/dada2_table.qza \
    --p-axis "sample" \
    --m-metadata-file $data_dir/metadata_infant_time.tsv \
    --m-metadata-column infant_time \
    --p-mode mean-ceiling \
    --o-grouped-table $data_dir/table_collapsed.qza

log "Feature table collapsed successfully!"

log "Script to collapse feature table completed successfully!"