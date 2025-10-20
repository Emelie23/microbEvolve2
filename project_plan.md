# MicrobEvolve2 - Project Plan

# Step 1: Import, Quality Control, Denoising (Week 3)
Importing demultiplexed data
Importing metadata per_sample and per_age as separate .tsv files
Quality control and Denoising
Decide: 
- trunction length (for forward and reverse sequences)
- minimal overlap of forward and reversed reads

Ask TA on wednesday:
- what variability is acceptable? 
- try different truncation lengths and do the denoising
- keep the overlap constant and vary the trunc-len

- does my qza file have information about metadata sample id?

- what does the variable: number of sample tell su

# Step 2: Taxonomic classification (Week 5)

In case we want to use SILVA as ref database to train our model:
- SILVA database contains information about environment and host
- optional: extra curation
- decide if we want to use species level annotations (75% of genus level does not match the species) if we want to use them - we'll need to find a solution. Rice is not a bacteria.

# Step 3:
