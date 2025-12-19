#!/bin/bash

#SBATCH --job-name=ritme_optimization
#SBATCH --time=03:59:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem-per-cpu=10G
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err

# BROKEN

module load eth_proxy

set -x

echo "SLURM_CPUS_PER_TASK: $SLURM_CPUS_PER_TASK"
echo "SLURM_GPUS: $SLURM_GPUS"

cd $HOME/microbEvolve2

# ! USER SETTINGS HERE
# -> config file to use
CONFIG="scripts/ritme/config/v1_experiment.json"
# -> path to the metadata file
PATH_MD="data/raw/metadata.tsv"
# -> path to the feature table file
PATH_FT="data/raw/dada2_table.qza"
# -> path to taxonomy file
PATH_TAX="data/raw/taxonomy_weighted_stool.qza"
# -> path to phylogeny file
# PATH_PHYLO=
# -> path to the .env file
# ENV_PATH="../../.env"
# -> path to store model logs
LOGS_DIR="data/ritme"
# -> path to data splits
PATH_DATA_SPLITS="data/ritme/data_splits"
# -> group columns for train-test split
GROUP_BY_COLUMN="infant_id"

# if your number of threads are limited increase as needed
ulimit -u 60000
ulimit -n 524288
# ! USER END __________

# # CLI version
if [[ -f "${PATH_DATA_SPLITS}/train_val.pkl" && -f "${PATH_DATA_SPLITS}/test.pkl" ]]; then
    echo "train_val.pkl and test.pkl already exist. Skipping split-train-test."
else
    echo "Running split-train-test"
    mkdir -p "$PATH_DATA_SPLITS"
    ritme split-train-test "$PATH_DATA_SPLITS" "$PATH_MD" "$PATH_FT" --group-by-column "$GROUP_BY_COLUMN" --train-size 0.8 --seed 12
fi

echo "Running find-best-model-config"
mkdir -p "$LOGS_DIR"
ritme find-best-model-config $CONFIG "${PATH_DATA_SPLITS}/train_val.pkl" --path-to-tax $PATH_TAX --path-store-model-logs $LOGS_DIR

echo "Running evaluate-tuned-models"
# Read the value of "experiment_tag" from the config file
experiment_tag=$(python -c "import json, sys; print(json.load(open('$CONFIG'))['experiment_tag'])")

ritme evaluate-tuned-models "${LOGS_DIR}/${experiment_tag}" "${PATH_DATA_SPLITS}/train_val.pkl" "${PATH_DATA_SPLITS}/test.pkl"

sstat -j $SLURM_JOB_ID

# get elapsed time of job
echo "TIME COUNTER:"
sacct -j $SLURM_JOB_ID --format=elapsed --allocations
