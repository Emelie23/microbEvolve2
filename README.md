# MicrobEvolve2

An infant gut microbiome analysis project focused on 16S rRNA amplicon sequencing data processing and analysis.

## Project Overview

<!-- TODO -->

## Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Emelie23/microbEvolve2.git
   cd microbEvolve2
   ```

2. **Install minconda:**
   See [installation instructions](https://docs.conda.io/projects/conda/en/stable/user-guide/install/index.html) for your platform.

3. **Create and activate the conda environment:**

A QIIME 2025.07 environment with q2-boots and q2-kmerizer is needed. Additional dependencies are `openpyxl`, `plotly` and `gseapy`.
A QIIME 2025.10 environment does not work at the moment, due to a [bug](https://forum.qiime2.org/t/demux-summarize-broken-after-upgrading-from-2025-7-to-2025-10/33852) regarding the demux plugin.

For **macOS**:

```bash
CONDA_SUBDIR=osx-64 conda env create \
    --name microbEvolve \
    --file environment_mac.yml \
    --solver=libmamba
conda activate microbEvolve
conda config --env --set subdir osx-64
```

For **Linux**:

```bash
conda env create \
    --name microbEvolve \
    --file environment.yml \
    --solver=libmamba
conda activate microbEvolve
```

For **Windows**:

    Please install Linux.

In case openpyxl installation fails, try installing with pip (`pip install openpyxl`).

4. **Verify installation:**

    ```bash
    qiime --version
    ```

## Project Structure

The analysis of this project is organized into five sections: 
- 01 Preprocessing
- 02 Diversity
- 03 Inter-Infant differences and temporal trajectories
- 04 Compositional changes over time
- 05 Changes and prediction of behavioural outcome measures

The Jupiter notebooks are located in the `scripts`directory.

All notebooks follow the same structure. Each step contains a short explanation, followed by the corresponding code. For computationally light steps, the code is written directly in the notebook cell. For more demanding steps, the cell calls an external script. These external scripts are located in the directory `scripts/src`. Most of them were run on Euler, and many include the matching submission file in case you want to run the job on the cluster.

Additional exploratory or parameter-testing scripts are stored in the `archive` directory. They are not directly included in the notebooks, but the documentation of each step notes when archived code contributed to the final version.

Please submit jobs on Euler from the `scripts` directory to ensure that all relative paths resolve correctly.

```
microbevolve2/
├── README.md                                          # This file
├── data/                                              # Data files
│   ├── raw/                                           # Raw QIIME2 artifacts (.qza files) and metadata (.tsv files)
│   └── processed/                                     # Processed visualizations (.qzv files)
├── scripts/                                           # JupiterNotebooks and analysis shell scripts
│   ├── 01-1_preprocessing                             # Preprocessing Notebook
│   ├── 01-2_featuretable_metadata_preparation.ipynb   # Featuretable and Metadata preparation Notebook
│   ├── 02_diversity.ipynb                             # Diversity Notebook
│   ├── 03_diversity_significance.ipynb                # Statistical Testing Diversity Notebook
│   ├── 04-1_differential_abundance.ipynb              # Differential Abundance Notebook
│   ├── 04-2_functional_annotoation.ipynb              # Functional Annotation Notebook
│   ├── 05-1_correlations.ipynb                        # Outcome measure correlation Notebook
│   ├── 05-2_prediction.ipynb                          # Outcome measure prediction Notebook
│   ├── src/                                           # Shell Scripts containing the code
│   ├── figures/                                       # Tracked Figures used in Notebooks (workflow images)
│   └── ritme/                                         # XXX
├── report/                                            # Reports
│   ├── midterm/                                       # Midterm report
│   └── final_project/                                 # Final project report
└── archive/                                           # Archived scripts and old versions
````

## Usage

### Quick Start

1. **Activate the environment:**
   ```bash
   conda activate microbevolve2
   ```

2. **Run the analysis pipeline:**
<!-- TODO -->

---

## Documentation

### Metadata

- **Sample Number**:

    `sample_number` in the `data/raw/metadata_per_sample.tsv` file refers to the order of the sample from an infant at a time point. The pediatrician takes as many samples from the infant as possible (which depends on how often it poops) and the number indicates the order.
    We can look at changes in the composition between these samples, as the microbiome usually fluctuates depending on food intake and other factors.
    We can use those samples in other analyses by either using all samples and controlling for the infant or by defining a reference microbiome for this time point, for example using the average or median abundance of taxa.

### Denoising

#### Cutadapt

Because the V4 region of the 16s RNA gene is shorter than our read length, we expect to see read-through and our primers in the sequences. As we do not want to include this nonsense information, we decided to analyze our reads with cutadapt prior to denoising.

1. Initial Trimming Attempt (Original and Modified Primers)

The first attempt used the known V4 specific forward and reverse primer sequences ([source](https://earthmicrobiome.ucsd.edu/protocols-and-standards/16s/)). I used the `--p-discard-untrimmed True` flag in order to see how many reads would be trimmed.
- This step resulted in zero sequences being trimmed or retained.
- In hindsight, it is irrelevant if the original or modified primers are used, as they are not required to match perfectly and the one base difference does not influence the result.
- This indicated that the forward and reverse primers were already removed from the sequences by the sequencing facility prior to data delivery. This was also confirmed by our TA. Because I anchored the primers, the `--p-discard-untrimmed True` setting caused all reads to be discarded even if the reverse complement might be present.

2. Identifying and Trimming Read-Through (Successful Strategy)

To be able to identify read-through, even though the forward and reverse primers had already been removed from the sequences, I decided to only look for the reverse complement of the primers.
- Approximately 4.5 million sequences were successfully trimmed and retained using this approach, which confirms the presence of read-through.
- The successful trim yielded reads with an approximate length of 250 bases, which likely represents the true length of the amplicon.
- Many reverse reads were longer than 250 bases, suggesting that the low base quality towards the end prevented cutadapt from recognizing the reverse-complement forward primer due to many mismatches.

#### Denoising with DADA2

Even though we could have used the trimmed reads from the previous step, we decided to simply truncate them aggressively in the denoising step directly.
A truncation length of 220 basses for the forward reads and 200 bass pairs for the reverse reads resulted in good denoising performance. Around 90% of the reads passed the filtering step and nearly all of those reads were able to be merged.

### Taxonomic classification

To assess the impact of prior knowledge on assignment accuracy, we compare two pre-trained classifiers targeting the 16S rRNA V4 region (515F/806R) from the SILVA 138.2 database (99% NR):
- Weighted (Stool-Optimized) Classifier: This classifier incorporates weights derived from a large database of human stool samples. This is designed to improve classification accuracy for samples derived from the human gut by prioritizing taxa commonly found in that environment.
- Unweighted Classifier: This is the standard Naive Bayes classifier, which treats all reference sequences in the database equally.

We can now try to assess differences in classification between the two approaches.


### Rarefaction

We used alpha rarefaction to evaluate how sequencing depth affects within-sample diversity and to select a depth that preserves both diversity estimates and sample retention. Depths of 20 000 and 15 000 reads would have removed many samples without providing meaningful improvements in diversity estimates. The Shannon curves showed a steep rise up to roughly 5 000 reads and then reached a near-plateau between 5 000 and 10 000 reads, which indicates that the overall community structure is already captured in this range. The observed-features curves increased more slowly and did not fully plateau, which is expected for richness metrics, but the additional features gained beyond 9 000 reads were small compared with the large rise at low depths. 

9 000 reads therefore retain almost all samples while still lying in the stability range indicated by the Shannon curves. We therefore set the sampling depth to 9 000 reads as a balanced choice that preserves diversity saturation and maximizes sample retention.


### Alpha diversity 

We compared k-mer sizes 12, 14, and 16 to identify the parameter that best preserves within-sample diversity patterns across the 2-, 4-, and 6-month groups.

We first tested how k-mer size affects within-sample diversity: Shannon entropy and Pielou’s evenness remained nearly identical across all three k-mer sizes.
This stability shows that alpha-diversity estimates do not depend on the k-mer choice and that the observed patterns are not artifacts of the parameter.
Because k-mer 12 reproduced the same diversity structure as k-mer 14 and 16 but with fewer computational demands, it offered the most efficient representation.
We also checked how the first two PCoA axes from Bray–Curtis behaved: The cumulative variance explained declined slightly with increasing k-mer size (48% -> 47%->46%).
This trend supported the broader impression that larger k-mers did not capture additional structure.

Conclusion
We selected k-mer 12 because it produced stable Shannon and Pielou estimates that matched those from larger k-mers while avoiding unnecessary parameter inflation. The alpha-diversity consistency across 12, 14, and 16 provided the strongest evidence that k-mer 12 is the appropriate and efficient choice for downstream analyses.


### Alpha significance 

Our analysis revealed distinct developmental phases depending on the diversity metric applied. The Shannon index, which accounts for both richness and evenness, showed a trend toward significance (p=0.059) driven primarily by changes between 2 and 4 months. However, this early shift was not sustained at 6 months, suggesting high inter-individual variability at the later timepoint. 
Conversely, Pielou’s Evenness showed early stability followed by later disruption. Evenness remained constant between 2 and 4 months (p=0.42) but shifted significantly between 4 and 6 months (p=0.01). 

This discrepancy implies that early microbiome development (2–4 months) is characterized by changes in species richness within a stable hierarchy, whereas the transition to 6 months involves a structural reorganization of microbial dominance.


### Spearman correlation

Spearman correlation analysis revealed significant associations between alpha diversity and metadata. Interestingly, while behavioral development was negatively correlated with Shannon diversity (R=-0.27, p=0.007), markers of sleep health showed the opposite trend. Both sleep rhythmicity (R=0.25, p=0.03) and sleep quality (R=0.20, p=0.049) were positively associated with Shannon diversity, suggesting a link between microbiome richness and circadian regulation. Furthermore, we observed a significant psychosocial connection: higher 'Parent Attuned Caring' scores correlated with increased Pielou’s Evenness (R=0.27, p=0.008), suggesting that a responsive caregiving environment may support a more ecologically balanced gut community in infants. However, the correlation strength is weak-to-moderate, suggesting that parenting style is only a contributing factor.

-->Behavioral development associates with less diverse, more concentrated microbial communities
-->Sleep health associates with more diverse communities
-->Attuned caregiving associates with more even communities


### Beta diversity
We evaluated the temporal development of the gut microbiome using two statistical approaches. A preliminary, cross-sectional PERMANOVA on the complete (unfiltered) dataset suggested that the microbiome was stable during the exclusive milk-feeding period, showing no significant difference between the 2-month and 4-month-old groups (p = 0.363). This initial analysis only detected the major shift occurring after 4 months, with highly significant differences between the 6-month-old group and both the 2-month-old (p = 0.001) and 4-month-old (p = 0.002) groups.

However, this cross-sectional method is confounded by high inter-individual variability. To account for this, we performed a more sensitive longitudinal (repeated-measures) analysis, focusing only on infants with complete samples for all three time points. This analysis revealed a pattern of continuous maturation. In this paired cohort, significant shifts were evident between all groups: 2 vs. 4 months (p = 0.039), 2 vs. 6 months (p = 0.029), and 4 vs. 6 months (p = 0.031).
These results clarify that the substantial "noise" from differences between infants in the full dataset had masked the subtle but significant developmental trajectory occurring within infants between 2 and 4 months. Therefore, the microbiome is not static but undergoes continuous, significant evolution throughout the first six months of life, even prior to the introduction of solid foods.


### PCoA and UMAP

PCoA and UMAP are used to visualize the diversity between samples and how it relates to metadata. Both PCoA and UMAP can be used to reduce dimensions, they however follow a different approach: 
PCoA: 
- linear method - tries to fit high dimensional data onto a straight axis in lower dimensions. If samples however show non-linear patterns PCoA may flatten or overlap them, potentially hiding local relationships
- preseves global distance - good for showing overall sample separation but may not distinguish local clusters
UMAP: 
- non-linear - can bend and stretch the space to preserve local neighborhoods
- preservs local clusters and also approximates for global structure (can be tuned with parameters)

Both Bray-Curtis and Jaccard produce a distance matrix to describe dissimilarities inbetween samples. 
Jaccard:
- uses presence/absence data only
- measures how many features are shared between two samples
Bray-Curtis:
- uses abundance data
- measures dissimilarity in terms of presence and abundance of features

## Differential Abundance
We used Acomb2 to perform differential abundance, as it allows to control for batch effects. We decided to use feature table and metadat which contains one representative sample per infant per timepoint.