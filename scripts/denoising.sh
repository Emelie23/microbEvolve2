#!/bin/bash

data_dir="$HOME/microbEvolve2/data"

qiime dada2 denoise-paired \
    --i-demultiplexed-seqs $data_dir/demux_paired_end.qza \
#    --p-trunc-len-f 3' of forward sequence\
#   --p-trunc-len-r  3' of reverse sequence\
#   --p-trim-left-f  5' of forward sequence\
#   --p-trim-left-r  5' of reverse sequence\
#   --p-min-overlap \
    --p-n-threads 3 \
    --o-table $data_dir/dada2_table.qza \
    --o-representative-sequences $data_dir/dada2_rep_set.qza \
    --o-denoising-stats $data_dir/dada2_stats.qza

qiime metadata tabulate \
    --m-input-file $data_dir/dada2_stats.qza \
    --o-visualization $data_dir/dada2_stats.qzv

qiime feature-table tabulate-seqs \
    --i-data $data_dir/dada2_rep_set.qza \
    --o-visualization $data_dir/dada2_rep_set.qzv

qiime feature-table summarize \
    --i-table $data_dir/dada2_table.qza \
#   --m-sample-metadata-file $data_dir/metadata_per_sample.tsv \
    --o-visualization $data_dir/dada2_table.qzv