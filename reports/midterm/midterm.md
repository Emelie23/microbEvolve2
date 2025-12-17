# MidTerm Notes

## Problem (Emelie):
Our project studies how the gut microbiome of infants changes during the first six months of life and whether these changes relate to behavior and sleep patterns. We analyze samples taken at 2, 4, and 6 months to track how microbial composition and diversity develop over time. The microbiome typically becomes more diverse and stable as new bacterial groups establish and early colonizers decrease in dominance. By comparing these microbial trends with measures of sleep rhythm, sleep quality, and behavior, we aim to explore possible connections between early gut development and infant well-being.

try to predict behavioral, sleep rhythm and sleep quality with the microbiome composition, diversity. 

Try to describe the change of microbiome over time. Find common charasteristics across development. 

## What we have done so far (Yara):

## Plan:

Steps to tackle the challenge:
- Merge available metadata to our frequency feature table to use code for this downstream
- Taxonomic analysis of our samples to be able to use this later for stratification of microbiomes etc.
- perform diversity analysis (k-mer based would not require us to do phylogeny)
- Perform initial exploration of potential correlations of diversity metrics and behavioral outcome measures.
- Look into temporal changes of the microbiome over all samples (common/characteristic trajectories?). Don't know what metric is usable (maybe beta-diversity or search literature (Bokulich 2016 paper has done something similar)).
- Perform exploratory clustering of the samples based on microbiome composition (maybe using DB-Scan or simple UMAP) and see if we can map potential clusters to outcome measures.
- Predict outcome measures with frequency feature table e.g., using random forest or clustering algorithm (kNN)
  - With these steps we might also want to look into dimensionality reduction techniques (PCA), if the algorithms struggle with the high-dimensional data (especially as ratio number of samples/number of observations < 1)
- 
