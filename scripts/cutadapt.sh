#!/bin/bash

# This command trims primer sequences in the reads if they are found.
# Sequences taken from https://astrobiomike.github.io/amplicon/dada2_workflow_ex
# Untrimmed (no primers found) sequences are discarded; this allows us to see how many sequences contained primers.

qiime cutadapt trim-paired \\
    --i-demultiplexed-sequences data/raw/demux_paired_end.qza \\
    --p-adapter-f ^GTGCCAGCMGCCGCGGTAA...ATTAGAWACCCBDGTAGTCC \\
    --p-adapter-r ^GGACTACHVGGGTWTCTAAT...TTACCGCGGCKGCTGGCAC \\
    --p-discard-untrimmed True \\
    --o-trimmed-sequences data/raw/demux_paired_end_trimmed.qza

qiime demux summarize \\
    --i-data data/raw/demux_paired_end_trimmed.qza \\
    --o-visualization data/processed/demux_paired_end_trimmed.qzv

