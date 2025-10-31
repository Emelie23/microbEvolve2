#!/bin/bash

data_dir="$HOME/microbEvolve2/data"

#summary of the reads in that feature table 
qiime feature-table summarize \
    --i-table $data_dir/raw/dada2_table.qza \
    --m-sample-metadata-file $data_dir/raw/metadata_per_sample.tsv \
    --o-visualization $data_dir/processed/dada2_table.qzv
    
    
#calculate the interactive alpha-rarefaction curves
#estimate the optimal sampling depth
#results: observed_features vs sampling depth: 1000, number of samples vs sequencing depth: 2000
qiime diversity alpha-rarefaction \
    --i-table $data_dir/raw/dada2_table.qza \
    --p-max-depth 10000 \
    --m-metadata-file $data_dir/raw/metadata_per_sample.tsv \
    --o-visualization $data_dir/processed/alpha-rarefaction.qzv

#collapse feature table (reduces feature richness; decide if necessary)
qiime taxa collapse \
  --i-table $data_dir/raw/dada2_table.qza \
  --i-taxonomy $data_dir/raw/taxonomy_unweighted.qza \
  --p-level 7 \
  --o-collapsed-table $data_dir/processed/collapsed-table-l7
  
#boots plugin recommended
qiime boots core-metrics \
    --i-table $data_dir/processed/collapsed-table-l7.qza \
    --m-metadata-file $data_dir/raw/metadata_per_sample.tsv \
    --p-sampling-depth 20 \
    --p-n 10 \
    --p-replacement \
    --p-alpha-average-method median \
    --p-beta-average-method medoid \
    --o-resampled-tables $data_dir/processed/bootstrap-tables/ \
    --o-alpha-diversities $data_dir/processed/bootstrap-alpha-diversities/ \
    --o-distance-matrices $data_dir/processed/bootstrap-distance-matrices/ \
    --o-pcoas $data_dir/processed/bootstrap-pcoas/ \
    --o-emperor-plots $data_dir/processed/bootstrap-emperor-plots/ \
    --o-scatter-plot $data_dir/processed/scatter-plot.qzv
    
    
#sampling depth of 2000 sequences per sample 
qiime diversity core-metrics \
  --i-table $data_dir/raw/dada2_table.qza \
  --m-metadata-file $data_dir/raw/metadata_per_sample.tsv \
  --p-sampling-depth 2000 \
  --output-dir $data_dir/processed/core-metrics-results  


#runs a pipeline to decompose a set of input sequences (ASVs or OTUs) into kmers prior to performing the core-metrics action above
qiime kmerizer core-metrics \
  --i-table $data_dir/raw/dada2_table.qza \
  --i-sequences $data_dir/raw/dada2_rep_set.qza \
  --m-metadata-file $data_dir/raw/metadata_per_sample.tsv \
  --p-sampling-depth 2000 \
  --p-kmer-size 8 \
  --output-dir $data_dir/processed/kmerizer-results
  

#Test the associations between categorical metadata columns and Shannon's Entropy
#Kruskal-Wallis test

qiime diversity alpha-group-significance \
  --i-alpha-diversity $data_dir/processed/core-metrics-results/shannon_vector.qza \
  --m-metadata-file $data_dir/raw/metadata_per_sample.tsv \
  --o-visualization $data_dir/processed/core-metrics-results/shannon-group-significance.qzv 


#are numeric sample metadata columns correlated with microbial community richness
#implementation of Spearman correlation
qiime diversity alpha-correlation \
  --i-alpha-diversity $data_dir/processed/core-metrics-results/shannon_vector.qza \
  --m-metadata-file $data_dir/raw/metadata_per_sample.tsv \
  --o-visualization $data_dir/processed/core-metrics-results/shannon-group-significance-numeric.qzv  
  


