#!/bin/bash

data_dir="$HOME/microbEvolve2/data"

qiime demux summarize \
    --i-data $data_dir/demux_paired_end.qza \
    --o-visualization $data_dir/demux_paired_end.qzv
