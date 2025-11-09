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

    For macOS:

    ```bash
    conda env create \
        --name microbEvolve \
        --file https://raw.githubusercontent.com/qiime2/distributions/refs/heads/dev/2025.7/amplicon/released/qiime2-amplicon-macos-latest-conda.yml
    conda activate microbEvolve
    conda config --env --set subdir osx-64
    conda install openpyxl
    ```

    For Linux:

    ```bash
    conda env create \
        --name microbEvolve \
        --file https://raw.githubusercontent.com/qiime2/distributions/refs/heads/dev/2025.7/amplicon/released/qiime2-amplicon-ubuntu-latest-conda.yml
    conda activate microbEvolve
    conda install openpyxl
    ```

    In case openpyxl installation fails, try installing with pip (`pip install openpyxl`).

4. **Verify installation:**

    ```bash
    qiime --version
    ```

## Project Structure

```
microbEvolve2/
├── README.md                  # This file
├── project_plan.md            # (Detailed) project planning
├── data/                      # Data files
│   ├── raw/                   # Raw QIIME2 artifacts (.qza files)
│   └── processed/             # Processed visualizations (.qzv files)
├── scripts/                   # Analysis scripts
│   ├── importing.sh           # Data import scripts
│   ├── quality_control.sh     # Quality control analysis
│   ├── cutadapt.sh            # Primer trimming
│   ├── denoising.sh           # DADA2 denoising
│   └── taxonomy.sh            # Taxonomic classification
├── reports/                   # Reports
└── archive/                   # Archived scripts and old versions
```

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

To determine the optimal k-mer size for the analysis, we conducted a comparative study using k-mer sizes 12, 14, and 16. The objective was to identify the parameter that provided the most robust and statistically powerful separation between the 2, 4, and 6-month-old sample groups.

1. Alpha diversity stability assessment
- The impact of k-mer size on within-sample diversity was assessed first
- Results for both Shannon Entropy and Pielou's Evenness were found to be highly stable and consistent across all three k-mer sizes
- This indicates that the alpha diversity findings are robust and not an artifact of this specific parameter choice
    
- We then compared the cumulative variance explained by the first two principal coordinates (PC1 + PC2) from the Bray-Curtis PCoA (a quantitative metric).
    
2. A descending trend in explanatory power was observed as the k-mer size increased:
- k-mer 12: 48% variance explained
- k-mer 14: 47% variance explained
- k-mer 16: 46% variance explained
    
2. Conclusion
- The k-mer 12 analysis captured the most variance, demonstrating it is the most accurate and powerful representation of the community structure in this dataset
- Therefore, a k-mer size of 12 was selected as the optimal parameter for all downstream diversity analyses


### Beta diversity

The statistical significance of the differences in microbiome composition between age groups was evaluated using a PERMANOVA test on the Bray-Curtis distance matrix. The analysis revealed a non-significant difference between the 2-month and 4-month-old groups (p-value = 0.363), indicating that the gut microbiome remains relatively stable during this initial period of exclusive milk feeding. In contrast, highly significant differences were observed between the 6-month-old group and both the 2-month-old (p-value = 0.001) and 4-month-old (p-value = 0.002) groups. These results strongly suggest a major shift in community structure occurs after 4 months of age, likely driven by the introduction of complementary solid foods (weaning), which establishes a distinct, more mature microbiome profile by 6 months.
