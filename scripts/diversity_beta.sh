#!/bin/bash

data_dir="data"

    
#PERMANOVA test checking whether the observed categories are significantly grouped
qiime diversity beta-group-significance \
    --i-distance-matrix $data_dir/raw/boots_kmer_diversity_collapsed/distance_matrices/braycurtis.qza \
    --m-metadata-file $data_dir/raw/metadata_collapsed_withtypes.tsv \
    --m-metadata-column timepoint \
    --p-pairwise \
    --o-visualization $data_dir/processed/braycurtis_significance_timepoint.qzv


qiime diversity beta-group-significance \
    --i-distance-matrix $data_dir/raw/boots_kmer_diversity/distance_matrices/braycurtis.qza \
    --m-metadata-file $data_dir/raw/metadata_withtypes.tsv \
    --m-metadata-column infant_id \
    --p-pairwise \
    --o-visualization $data_dir/processed/braycurtis_significance_infant.qzv
