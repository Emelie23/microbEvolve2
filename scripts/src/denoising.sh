#!/bin/bash

data_dir="../data"

qiime dada2 denoise-paired \
    --i-demultiplexed-seqs $data_dir/raw/demux_paired_end.qza \
    --p-trunc-len-f 220 \
    --p-trunc-len-r  200 \
    --p-n-threads 10 \
    --o-table $data_dir/raw/dada2_table.qza \
    --o-representative-sequences $data_dir/raw/dada2_rep_set.qza \
    --o-denoising-stats $data_dir/raw/dada2_stats.qza

qiime metadata tabulate \
    --m-input-file $data_dir/raw/dada2_stats.qza \
    --o-visualization $data_dir/processed/dada2_stats.qzv

qiime feature-table tabulate-seqs \
    --i-data $data_dir/raw/dada2_rep_set.qza \
    --o-visualization $data_dir/processed/dada2_rep_set.qzv

qiime feature-table summarize \
    --i-table $data_dir/raw/dada2_table.qza \
    --m-sample-metadata-file $data_dir/raw/metadata_per_sample.tsv \
    --o-visualization $data_dir/processed/dada2_table.qzv
