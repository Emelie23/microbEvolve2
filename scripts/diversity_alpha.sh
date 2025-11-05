#!/bin/bash

data_dir="$HOME/microbEvolve2/data"


#calculate the interactive alpha-rarefaction curves
#estimate the optimal sampling depth
#max depth experiment
! qiime diversity alpha-rarefaction \
    --i-table $data_dir/raw/dada2_table.qza \
    --p-max-depth 35566 \
    --m-metadata-file $data_dir/raw/metadata_per_sample.tsv \
    --o-visualization $data_dir/processed/alpha-rarefaction.qzv
    
    
#boots plugin recommended
#p-n=number of bootstrap replicates
! qiime boots kmer-diversity \
    --i-table $data_dir/raw/dada2_table.qza \
    --i-sequences $data_dir/raw/dada2_rep_set.qza \
    --m-metadata-file $data_dir/raw/metadata_per_sample.tsv \
    --p-sampling-depth 9000 \
    --p-n 10 \
    --p-kmer-size 12 \
    --p-replacement \
    --p-alpha-average-method median \
    --p-beta-average-method medoid \
    --output-dir $data_dir/processed/boots-kmer-diversity


#boots plugin recommended
#p-n=number of bootstrap replicates
! qiime boots kmer-diversity \
    --i-table $data_dir/raw/dada2_table.qza \
    --i-sequences $data_dir/raw/dada2_rep_set.qza \
    --m-metadata-file $data_dir/raw/metadata_per_sample.tsv \
    --p-sampling-depth 9000 \
    --p-n 10 \
    --p-kmer-size 14 \
    --p-replacement \
    --p-alpha-average-method median \
    --p-beta-average-method medoid \
    --output-dir $data_dir/processed/boots-kmer-diversity_14
    
    
    
#boots plugin recommended
#p-n=number of bootstrap replicates
! qiime boots kmer-diversity \
    --i-table $data_dir/raw/dada2_table.qza \
    --i-sequences $data_dir/raw/dada2_rep_set.qza \
    --m-metadata-file $data_dir/raw/metadata_per_sample.tsv \
    --p-sampling-depth 9000 \
    --p-n 10 \
    --p-kmer-size 16 \
    --p-replacement \
    --p-alpha-average-method median \
    --p-beta-average-method medoid \
    --output-dir $data_dir/processed/boots-kmer-diversity_16



#collapse feature table only when neessary, only if I want to group by taxonomy
! qiime taxa collapse \
  --i-table $data_dir/raw/dada2_table.qza \
  --i-taxonomy $data_dir/raw/taxonomy_unweighted.qza \
  --p-level 6 \
  --o-collapsed-table $data_dir/processed/collapsed-table-l6
  
  
  
  
