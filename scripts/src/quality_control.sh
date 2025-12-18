#!/bin/bash

data_dir="../data"

mkdir -p "$data_dir/raw"
mkdir -p "$data_dir/processed"

qiime demux summarize \
    --i-data $data_dir/raw/demux_paired_end.qza \
    --o-visualization $data_dir/processed/demux_paired_end.qzv
