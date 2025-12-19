# MicrobEvolve2

This project was carried out as part of the "Applied Bioinformatics: Microbiome" course taught by Prof. Nicolas Bokulich and supervised by Fannie Kerff.
It focuses on processing and analysis of 16S rRNA amplicon sequencing data from infant gut microbiome samles.

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
│   └── ritme/                                         # Scripts and config for ritme framework
├── report/                                            # Reports
│   ├── midterm/                                       # Midterm report
│   └── final_project/                                 # Final project report
└── archive/                                           # Archived scripts and old versions
````

## Usage

All Jupyter Notebooks have been executed and should include saved output, such as figures. 
In case you only want to follow the analysis steps, looking through the notebooks and scripts should be sufficient.
In case you wish for more detailed insights, you can run the notebooks yourself. Please note that they need to be run sequentially, as indicated by the filenames, as some analysis depend on the output of other notebooks. At the top of each notebook a shell command indicates how the respective notebook can be executed on a SLURM cluster such as Euler.

Visualizations and artifacts created by QIIME are not being tracked in this repo. Therefore you either need to perform all analysis steps individually or download the relevant data. We provide all artifacts and visualizations hosted on [polybox](https://polybox.ethz.ch/index.php/s/CxrMwtmmzGmgXjc).
