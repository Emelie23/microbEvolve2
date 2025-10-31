#!/bin/bash

data_dir="$HOME/microbEvolve2/data"

#PERMANOVA test checking whether the observed categories are significantly grouped
qiime diversity beta-group-significance \
    --i-distance-matrix $data_dir/kmerizer-results/bray_curtis_distance_matrix.qza \
    --m-metadata-file $data_dir/raw/metadata_per_sample.tsv \
    --m-metadata-column \
    --p-pairwise \
    --o-visualization $data_dir/kmerizer-results/bray_curtis-env-significance.qzv
    

qiime diversity beta-group-significance \
    --i-distance-matrix $data_dir/core-metrics-results/bray_curtis_distance_matrix.qza \
    --m-metadata-file $data_dir/raw/metadata_per_sample.tsv \
    --m-metadata-column \
    --p-pairwise \
    --o-visualization $data_dir/core-metrics-results/bray_curtis-env-significance.qzv