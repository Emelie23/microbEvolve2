#!/bin/bash

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

data_dir="$HOME/microbEvolve2/data"
mkdir -p "$data_dir/raw"

log "Downloading unweighted classifier from SILVA database..."

wget -O "$data_dir/raw/silva-138-99-515-806-nb-classifier-unweighted.qza" \
    "https://www.arb-silva.de/fileadmin/silva_databases/current/QIIME2/2025.7/SSU/V4-515f-806r/uniform/SILVA138.2_SSURef_NR99_uniform_classifier_V4-515f-806r.qza"

log "Unweighted classifier downloaded successfully"
log "Downloading weighted classifier for human stool samples..."

wget -O "$data_dir/raw/silva-138-99-515-806-nb-classifier-weighted-stool.qza" \
    https://www.arb-silva.de/fileadmin/silva_databases/current/QIIME2/2025.7/SSU/V4-515f-806r/weighted/human-stool/SILVA138.2_SSURef_NR99_weighted_classifier_V4-515f-806r_human-stool.qza

log "Weighted classifier downloaded successfully"
