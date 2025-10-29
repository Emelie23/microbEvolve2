# MicrobEvolve2 - Project Plan

# Step 1: Import, Quality Control
- Importing demultiplexed data
- Importing metadata per_sample and per_age as separate .tsv files
- Quality control

# Step 2: Denoising
- truncation length (for forward and reverse sequences)
- minimal overlap of forward and reversed reads
  - The primers used for V4 amplicon sequencing are most probably 515F & 806R [source](https://pmc.ncbi.nlm.nih.gov/articles/PMC8544895/).
  - This would result in amplicons with lengths around 350 to 400 bps [source](https://www.microbiotavault.org/wp-content/uploads/2025/06/SOP_16S-rRNA-amplicon-sequencing_v1.pdf) or 300 to 350 bps [EarthMicrobiome Protocls](https://earthmicrobiome.ucsd.edu/protocols-and-standards/16s/).
  - As our reads are 301 bps long, our overlap is roughly 200 bps.
  - We could truncate quite aggressively. We probably do not need to, as our read quality is quite good over a long stretch.

REPORT: Describe process of parameter selection, that we had very high filtering and low merging, that we used cutadapt. But then only provide the final script, we can maybe point to the other scripts in case they want to look at them. 

# Step 3: Taxonomic classification
In case we want to use SILVA as ref database to train our model:
- SILVA database contains information about environment and host
- optional: extra curation
- decide if we want to use species level annotations (75% of genus level does not match the species) if we want to use them, we'll need to find a solution. Example: rice is not a bacterium.

REPORT: Describe that we had problems with the memory when importing the classifier - and how we solved it! Important to include such workflows.  

# Step 4: Alpha and beta diversity
