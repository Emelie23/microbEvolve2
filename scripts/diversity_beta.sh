#!/bin/bash

data_dir="$HOME/microbEvolve2/data"

#PERMANOVA test checking whether the observed categories are significantly grouped
qiime diversity beta-group-significance \
    --i-distance-matrix $data_dir/raw/boots_kmer_diversity/distance_matrices/braycurtis.qza \
    --m-metadata-file $data_dir/raw/metadata.tsv \
    --m-metadata-column timepoint \
    --p-pairwise \
    --o-visualization $data_dir/processed/boots_kmer_diversity/distance_matrices/braycurtis_significance \

#new filtered table containing filtered data
qiime feature-table filter-samples \
  --i-table /home/jovyan/microbEvolve2/data/raw/dada2_table.qza \
  --m-metadata-file metadata_filtered.tsv \
  --o-filtered-table $data_dir/raw/infants_2_4_6_months.qza

qiime diversity beta \
  --i-table /home/jovyan/microbEvolve2/data/raw/infants_2_4_6.qza \
  --p-metric braycurtis \
  --o-distance-matrix /home/jovyan/microbEvolve2/data/raw/infants_2_4_6_braycurtis.qza

qiime diversity beta-group-significance \
    --i-distance-matrix $data_dir/raw/infants_2_4_6_braycurtis.qza \
    --m-metadata-file $data_dir/raw/metadata_filtered.tsv \
    --m-metadata-column timepoint \
    --p-pairwise \
    --o-visualization $data_dir/raw/boots_kmer_diversity/distance_matrices/braycurtis_significance_filtered \
    
    
