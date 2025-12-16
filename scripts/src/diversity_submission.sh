#!/bin/bash

#SBATCH --job-name=microbEvolve2_diversity
#SBATCH --time=03:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=8G
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err
#SBATCH --mail-type=END,FAIL

start_time=$(date +%s)

# Create new environment boots (https://library.qiime2.org/plugins/caporaso-lab/q2-boots)
# Install kimerize (https://library.qiime2.org/plugins/bokulich-lab/q2-kmerizer)

source $HOME/.bashrc
conda activate boots

bash $HOME/microbEvolve2/scripts/src/diversity_alpha.sh

# Calculate duration
end_time=$(date +%s)
duration=$((end_time - start_time))
hours=$((duration / 3600))
minutes=$(( (duration % 3600) / 60 ))
seconds=$((duration % 60))

# Log job statistics
echo "========== JOB STATISTICS =========="
echo "End time: $(date)"
echo "Duration: ${hours}h ${minutes}m ${seconds}s"
echo "Job ID: $SLURM_JOB_ID"
echo "=================================="
