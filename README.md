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

All notebooks follow the same structure. Each step contains a short explanation, followed by the corresponding code. For computationally light steps, the code is written directly in the notebook cell. For more demanding steps, the cell calls an external script. These external scripts are located in the directory `scripts/src`.

Additional exploratory or parameter-testing scripts are stored in the `archive` directory. They are not directly included in the notebooks, but the documentation of each step notes when archived code contributed to the final version.

If you want to run the entire code yourself please read *Run analysis pipeline*: TODO

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
│   ├── figures/                                       # Tracked Figures used in Notebooks (e.g workflow images)
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