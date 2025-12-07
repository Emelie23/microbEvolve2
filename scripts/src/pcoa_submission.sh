#!/bin/bash

#SBATCH --job-name=microbEvolve2_pcoa
#SBATCH --time=01:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=2G
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err
#SBATCH --mail-type=END,FAIL

start_time=$(date +%s)

source $HOME/.bashrc
conda activate microbEvolve

bash $HOME/microbEvolve2/scripts/src/pcoa.sh

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
