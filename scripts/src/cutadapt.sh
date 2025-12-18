#!/bin/bash

set -e

export R_LIBS_USER=$CONDA_PREFIX/lib/R/library
export R_HOME=$CONDA_PREFIX/lib/R

# This command trims primer sequences in the reads if they are found.
# Sequences taken from https://astrobiomike.github.io/amplicon/dada2_workflow_ex
# Untrimmed (no primers found) sequences are discarded; this allows us to see how many sequences contained primers.

data_dir="../data"

# Initial trimming attempt (original and modified primers)
qiime cutadapt trim-paired \
    --i-demultiplexed-sequences $data_dir/raw/demux_paired_end.qza \
    --p-adapter-f ^GTGYCAGCMGCCGCGGTAA...ATTAGAWACCCBNGTAGTCC \
    --p-adapter-r ^GGACTACNVGGGTWTCTAAT...TTACCGCGGCKGCTGRCAC \
    --p-discard-untrimmed True \
    --o-trimmed-sequences $data_dir/raw/demux_paired_end_trimmed-modified-primers.qza

qiime demux summarize \
    --i-data $data_dir/raw/demux_paired_end_trimmed-modified-primers.qza \
    --o-visualization $data_dir/processed/demux_paired_end_trimmed-modified-primers.qzv

# Identifying and Trimming Read-Through (Successful Strategy)
qiime cutadapt trim-paired \
    --i-demultiplexed-sequences $data_dir/raw/demux_paired_end.qza \
    --p-adapter-f ATTAGAWACCCBDGTAGTCC \
    --p-adapter-r TTACCGCGGCKGCTGGCAC \
    --p-discard-untrimmed True \
    --o-trimmed-sequences $data_dir/raw/demux_paired_end_trimmed-original-primers.qza

qiime demux summarize \
    --i-data $data_dir/raw/demux_paired_end_trimmed-original-primers.qza \
    --o-visualization $data_dir/processed/demux_paired_end_trimmed-original-primers.qzv


