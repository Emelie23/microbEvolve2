#!/bin/bash

set -e

export R_LIBS_USER=$CONDA_PREFIX/lib/R/library
export R_HOME=$CONDA_PREFIX/lib/R

# This command trims primer sequences in the reads if they are found.
# Sequences taken from https://astrobiomike.github.io/amplicon/dada2_workflow_ex
# Untrimmed (no primers found) sequences are discarded; this allows us to see how many sequences contained primers.

qiime cutadapt trim-paired \
    --i-demultiplexed-sequences data/raw/demux_paired_end.qza \
    --p-adapter-f ATTAGAWACCCBDGTAGTCC \
    --p-adapter-r TTACCGCGGCKGCTGGCAC \
    --p-discard-untrimmed True \
    --o-trimmed-sequences data/raw/demux_paired_end_trimmed-original-primers.qza

qiime demux summarize \
    --i-data data/raw/demux_paired_end_trimmed-original-primers.qza \
    --o-visualization data/processed/demux_paired_end_trimmed-original-primers.qzv

# qiime cutadapt trim-paired \
#     --i-demultiplexed-sequences data/raw/demux_paired_end.qza \
#     --p-adapter-f ^GTGYCAGCMGCCGCGGTAA...ATTAGAWACCCBNGTAGTCC \
#     --p-adapter-r ^GGACTACNVGGGTWTCTAAT...TTACCGCGGCKGCTGRCAC \
#     --p-discard-untrimmed True \
#     --o-trimmed-sequences data/raw/demux_paired_end_trimmed-modified-primers.qza

# qiime demux summarize \
#     --i-data data/raw/demux_paired_end_trimmed-modified-primers.qza \
#     --o-visualization data/processed/demux_paired_end_trimmed-modified-primers.qzv
