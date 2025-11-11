#!/bin/bash

data_dir="$HOME/microbEvolve2/data"

#PERMANOVA test checking whether the observed categories are significantly grouped
qiime diversity beta-group-significance \
    --i-distance-matrix $data_dir/processed/boots-kmer-diversity/distance_matrices/braycurtis.qza \
    --m-metadata-file $data_dir/raw/metadata_per_sample.tsv \
    --m-metadata-column timepoint \
    --p-pairwise \
    --o-visualization $data_dir/processed/boots-kmer-diversity/distance_matrices/braycurtis_significance \





 