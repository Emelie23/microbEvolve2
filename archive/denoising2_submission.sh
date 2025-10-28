#!/bin/bash

#SBATCH --job-name=microbEvolve2_denoising2
#SBATCH --time=03:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=32G
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err

start_time=$(date +%s)

source $HOME/.bashrc
conda activate microbEvolve

python3 -u $HOME/microbEvolve2/scripts/denoising2.py

# Check if the Python script executed successfully
if [ $? -eq 0 ]; then
    echo "Denoising script completed successfully at $(date)"
else
    echo "Denoising script failed with exit code $? at $(date)"
fi

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
